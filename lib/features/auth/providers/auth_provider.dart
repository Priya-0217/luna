import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/core/services/auth_service.dart';
import 'package:her/core/services/database.dart';
import 'package:her/core/services/encryption_service.dart';
import 'package:her/features/auth/domain/app_user.dart';
import 'package:her/features/auth/data/auth_repository.dart';

part 'auth_provider.g.dart';

// ---------------------------------------------------------------------------
// Converts a Firebase [User] + Firestore data into our domain [AppUser].
// ---------------------------------------------------------------------------
AppUser _toAppUser(User firebaseUser, Map<String, dynamic>? firestoreData) {
  return AppUser(
    uid: firebaseUser.uid,
    email: firebaseUser.email ?? '',
    displayName:
        firestoreData?['displayName'] as String? ??
        firebaseUser.displayName ??
        '',
    cycleAverageLength: (firestoreData?['cycleAverageLength'] as int?) ?? 28,
    periodAverageLength: (firestoreData?['periodAverageLength'] as int?) ?? 5,
    isOnboarded: (firestoreData?['isOnboarded'] as bool?) ?? false,
    partnerUid: firestoreData?['partnerUid'] as String?,
    coupleId: firestoreData?['coupleId'] as String?,
    isLinked: (firestoreData?['isLinked'] as bool?) ?? false,
    role: firestoreData?['role'] as String?,
    myLoveCode: firestoreData?['myLoveCode'] as String?,
    partnerRole: firestoreData?['partnerRole'] as String?,
    partnerDisplayName: firestoreData?['partnerDisplayName'] as String?,
  );
}

// ---------------------------------------------------------------------------
// Auth provider — listens to Firebase authStateChanges stream and
// enriches the user with Firestore profile data.
// ---------------------------------------------------------------------------
@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<AppUser?> build() async {
    debugPrint('⏳ AuthProvider: Initializing auth state...');
    // Watch the Firebase auth-state stream.
    final userStream = ref.watch(authStateChangesProvider);

    if (userStream.value == null) {
      debugPrint('👤 AuthProvider: No active session (logged out)');
      return null;
    }
    final firebaseUser = userStream.value!;
    debugPrint(
      '👤 AuthProvider: Active Firebase user: ${firebaseUser.uid} (${firebaseUser.email})',
    );

    // Directly use a Stream for Firestore to ensure we react to role changes
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .snapshots()
        .map((doc) {
          final data = doc.data();
          debugPrint('🔄 AuthProvider: Firestore profile updated: $data');
          return _toAppUser(firebaseUser, data);
        })
        .first;
  }

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<void> login(String email, String password) async {
    debugPrint('🔑 AuthProvider: Login attempt for $email');
    state = const AsyncLoading();
    try {
      final service = ref.read(authServiceProvider);
      final credential = await service.signIn(email: email, password: password);
      final firebaseUser = credential.user!;
      debugPrint(
        '✅ AuthProvider: Firebase sign in success: ${firebaseUser.uid}',
      );

      // Fetch Firestore profile
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      final appUser = _toAppUser(firebaseUser, doc.data());
      debugPrint('✅ AuthProvider: Profile loaded for role: ${appUser.role}');
      state = AsyncData(appUser);

      // Force refresh of any providers depending on the role
      ref.invalidateSelf();
    } catch (e, st) {
      debugPrint('❌ AuthProvider: Login failed: $e');
      state = AsyncError(e, st);
    }
  }

  // ── Signup ─────────────────────────────────────────────────────────────────
  Future<void> signup(String name, String email, String password) async {
    debugPrint('🆕 AuthProvider: Signup attempt for $email ($name)');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(authServiceProvider);
      final credential = await service.createAccount(
        name: name,
        email: email,
        password: password,
      );
      final firebaseUser = credential.user!;
      debugPrint(
        '✅ AuthProvider: Firebase account created: ${firebaseUser.uid}',
      );

      // Fetch the newly-created Firestore doc
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      debugPrint('✅ AuthProvider: Initial profile stored');
      return _toAppUser(firebaseUser, doc.data());
    });
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    debugPrint('🧼 AuthProvider: Performing deep wipe and logout...');
    state = const AsyncLoading();

    try {
      // 1. Clear Local Database (Drift)
      await ref.read(appDatabaseProvider).clearAllData();
      debugPrint('🗄️ AuthProvider: Drift local database wiped');

      // 2. Clear Local Settings (Hive)
      await Hive.box('settings').clear();
      debugPrint('📦 AuthProvider: Hive settings cleared');

      // 3. Clear Secure Storage (Everything!)
      const secureStorage = FlutterSecureStorage();
      await secureStorage.deleteAll();
      debugPrint('🔑 AuthProvider: Secure storage wiped');

      // 4. Sign out from Firebase
      await ref.read(authServiceProvider).signOut();
      debugPrint('✅ AuthProvider: Firebase session terminated');

      state = const AsyncData(null);
    } catch (e, st) {
      debugPrint('❌ AuthProvider: Logout cleanup failed: $e');
      state = AsyncError(e, st);
    }
  }

  // ── Update Profile ──────────────────────────────────────────────────────────
  Future<void> updateProfile(AppUser updatedUser) async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.updateProfile(updatedUser);
    state = AsyncData(updatedUser);
  }

  // ── Refresh User State ──────────────────────────────────────────────────────
  Future<void> refresh() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      state = const AsyncData(null);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      return _toAppUser(firebaseUser, doc.data());
    });
  }

  // ── Sign Out Compatibility ──────────────────────────────────────────────────
  Future<void> signOut() => logout();
}
