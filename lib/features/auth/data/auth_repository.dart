import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final cred = await _auth.signIn(email: email, password: password);
    final fbUser = cred.user!;
    final data = await _firestore.getUserProfile();
    return AppUser(
      uid: fbUser.uid,
      email: fbUser.email ?? '',
      displayName: fbUser.displayName ?? data?['displayName'] ?? '',
      cycleAverageLength: (data?['cycleAverageLength'] as int?) ?? 28,
      periodAverageLength: (data?['periodAverageLength'] as int?) ?? 5,
    );
  }

  Future<AppUser> signUp(
      String name, String email, String password) async {
    final cred = await _auth.createAccount(
        name: name, email: email, password: password);
    final fbUser = cred.user!;
    return AppUser(
      uid: fbUser.uid,
      email: email,
      displayName: name,
    );
  }

  Future<void> updateProfile(AppUser user) async {
    await _firestore.saveUserProfile({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'cycleAverageLength': user.cycleAverageLength,
      'periodAverageLength': user.periodAverageLength,
      'isOnboarded': user.isOnboarded,
    });
    await FirebaseAuth.instance.currentUser
        ?.updateDisplayName(user.displayName);
  }

  Future<void> signOut() => _auth.signOut();
}
