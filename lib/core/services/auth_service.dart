import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

// ---------------------------------------------------------------------------
// Provider for the raw FirebaseAuth instance
// ---------------------------------------------------------------------------
@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

// ---------------------------------------------------------------------------
// Provider for the raw FirebaseFirestore instance
// ---------------------------------------------------------------------------
@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) => FirebaseFirestore.instance;

// ---------------------------------------------------------------------------
// Stream of Firebase auth-state changes (null = signed out)
// ---------------------------------------------------------------------------
@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
}

// ---------------------------------------------------------------------------
// AuthService — wraps all Firebase Auth operations
// ---------------------------------------------------------------------------
class AuthService {
  AuthService(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // Current signed-in Firebase user (null if signed out)
  User? get currentUser => _auth.currentUser;

  // ── Sign-up ───────────────────────────────────────────────────────────────
  Future<UserCredential> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update display name on the Firebase Auth profile
    await credential.user?.updateDisplayName(name);

    // Create the user document in Firestore
    await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .set({
      'uid': credential.user!.uid,
      'email': email,
      'displayName': name,
      'createdAt': FieldValue.serverTimestamp(),
      'cycleAverageLength': 28,
      'periodAverageLength': 5,
    }, SetOptions(merge: true));

    return credential;
  }

  // ── Sign-in ───────────────────────────────────────────────────────────────
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ── Sign-out ──────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── Password reset ────────────────────────────────────────────────────────
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

// ---------------------------------------------------------------------------
// Provider for AuthService
// ---------------------------------------------------------------------------
@riverpod
AuthService authService(Ref ref) {
  return AuthService(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFirestoreProvider),
  );
}
