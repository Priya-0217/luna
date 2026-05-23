import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/core/services/auth_service.dart';
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
    displayName: firebaseUser.displayName ??
        (firestoreData?['displayName'] as String? ?? ''),
    cycleAverageLength:
        (firestoreData?['cycleAverageLength'] as int?) ?? 28,
    periodAverageLength:
        (firestoreData?['periodAverageLength'] as int?) ?? 5,
    isOnboarded: (firestoreData?['isOnboarded'] as bool?) ?? false,
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
    // Watch the Firebase auth-state stream. Riverpod will rebuild when it
    // emits a new value (signed in / signed out).
    final userStream = ref.watch(authStateChangesProvider);

    return userStream.when(
      data: (firebaseUser) async {
        if (firebaseUser == null) return null;

        // Fetch extra profile fields from Firestore
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .get();
          return _toAppUser(firebaseUser, doc.data());
        } catch (_) {
          // If Firestore fetch fails, fall back to Firebase Auth data
          return _toAppUser(firebaseUser, null);
        }
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(authServiceProvider);
      final credential = await service.signIn(email: email, password: password);
      final firebaseUser = credential.user!;

      // Fetch Firestore profile
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      return _toAppUser(firebaseUser, doc.data());
    });
  }

  // ── Signup ─────────────────────────────────────────────────────────────────
  Future<void> signup(String name, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(authServiceProvider);
      final credential = await service.createAccount(
        name: name,
        email: email,
        password: password,
      );
      final firebaseUser = credential.user!;

      // Fetch the newly-created Firestore doc
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      return _toAppUser(firebaseUser, doc.data());
    });
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    state = const AsyncLoading();
    await ref.read(authServiceProvider).signOut();
    state = const AsyncData(null);
  }

  // ── Update Profile ──────────────────────────────────────────────────────────
  Future<void> updateProfile(AppUser updatedUser) async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.updateProfile(updatedUser);
    state = AsyncData(updatedUser);
  }
}
