import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/core/services/auth_service.dart';
import 'package:her/core/services/firestore_service.dart';
import 'package:her/features/auth/domain/app_user.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository(
  ref.watch(authServiceProvider),
  ref.watch(firestoreServiceProvider),
);

class AuthRepository {
  AuthRepository(this._auth, this._firestore);

  final AuthService _auth;
  final FirestoreService _firestore;

  User? get currentFirebaseUser => _auth.currentUser;

  Future<AppUser> signIn(String email, String password) async {
    debugPrint('🔐 AuthRepository: Attempting sign in for $email');
    try {
      final cred = await _auth.signIn(email: email, password: password);
      final fbUser = cred.user!;
      debugPrint(
        '✅ AuthRepository: Firebase sign in success for ${fbUser.uid}',
      );

      final data = await _firestore.getUserProfile();
      debugPrint('📄 AuthRepository: Fetched Firestore profile: $data');

      return AppUser(
        uid: fbUser.uid,
        email: fbUser.email ?? '',
        displayName: data?['displayName'] ?? fbUser.displayName ?? '',
        cycleAverageLength: (data?['cycleAverageLength'] as int?) ?? 28,
        periodAverageLength: (data?['periodAverageLength'] as int?) ?? 5,
        isOnboarded: (data?['isOnboarded'] as bool?) ?? false,
        role: data?['role'] as String?,
        partnerUid: data?['partnerUid'] as String?,
        coupleId: data?['coupleId'] as String?,
        isLinked: (data?['isLinked'] as bool?) ?? false,
        myLoveCode: data?['myLoveCode'] as String?,
        partnerRole: data?['partnerRole'] as String?,
        partnerDisplayName: data?['partnerDisplayName'] as String?,
      );
    } catch (e) {
      debugPrint('❌ AuthRepository: Sign in failed for $email: $e');
      rethrow;
    }
  }

  Future<AppUser> signUp(String name, String email, String password) async {
    debugPrint('🆕 AuthRepository: Creating account for $email ($name)');
    try {
      final cred = await _auth.createAccount(
        name: name,
        email: email,
        password: password,
      );
      final fbUser = cred.user!;
      debugPrint('✅ AuthRepository: Account created for ${fbUser.uid}');
      return AppUser(uid: fbUser.uid, email: email, displayName: name);
    } catch (e) {
      debugPrint('❌ AuthRepository: Sign up failed for $email: $e');
      rethrow;
    }
  }

  Future<void> updateProfile(AppUser user) async {
    debugPrint(
      '💾 AuthRepository: Syncing profile for ${user.email} to Firestore',
    );
    try {
      await _firestore.saveUserProfile({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'cycleAverageLength': user.cycleAverageLength,
        'periodAverageLength': user.periodAverageLength,
        'isOnboarded': user.isOnboarded,
        'role': user.role,
        'partnerUid': user.partnerUid,
        'coupleId': user.coupleId,
        'isLinked': user.isLinked,
        'myLoveCode': user.myLoveCode,
        'partnerRole': user.partnerRole,
        'partnerDisplayName': user.partnerDisplayName,
      });
      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        user.displayName,
      );
      debugPrint('✅ AuthRepository: Profile persisted for ${user.email}');
    } catch (e) {
      debugPrint(
        '❌ AuthRepository: Profile persistence failed for ${user.email}: $e',
      );
      rethrow;
    }
  }

  Future<void> signOut() {
    debugPrint('🚪 AuthRepository: Signing out current user');
    return _auth.signOut();
  }
}
