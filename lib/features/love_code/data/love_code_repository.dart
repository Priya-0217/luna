import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:her/features/love_code/domain/love_code.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'love_code_repository.g.dart';

class LoveCodeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  LoveCodeRepository(this._firestore, this._auth);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('loveCodes');

  /// Generate a love code using the Cloud Function.
  Future<String> generateCode() async {
    // Mocking for now: LUNA-XXXX-XXXX-1234
    const HER_WORDS_1 = [
      'ROSE',
      'DAWN',
      'SOFT',
      'SILK',
      'PETAL',
      'BLUSH',
      'BLOOM',
      'PEARL',
    ];
    const HER_WORDS_2 = [
      'MOON',
      'MIST',
      'GLOW',
      'HAZE',
      'LACE',
      'DUSK',
      'VEIL',
      'HALO',
    ];

    final w1 = HER_WORDS_1[DateTime.now().millisecond % HER_WORDS_1.length];
    final w2 = HER_WORDS_2[DateTime.now().second % HER_WORDS_2.length];
    final digits = (1000 + (DateTime.now().microsecond % 9000)).toString();

    return 'LUNA-$w1-$w2-$digits';
  }

  /// Get the love code document if it exists for the current user.
  Stream<LoveCode?> watchMyLoveCode() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(null);

    return _collection
        .where('ownerUid', isEqualTo: uid)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return LoveCode.fromJson(snapshot.docs.first.data());
        });
  }

  /// Get a love code by its string value.
  Future<LoveCode?> getLoveCode(String code) async {
    final doc = await _collection.doc(code).get();
    if (!doc.exists) return null;
    return LoveCode.fromJson(doc.data()!);
  }

  /// Link with a partner using their code.
  Future<void> linkWithPartner(String partnerCode) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not authenticated");

    final doc = await _collection.doc(partnerCode).get();
    if (!doc.exists) throw Exception("Invalid Love Code");

    final loveCode = LoveCode.fromJson(doc.data()!);
    if (!loveCode.isActive) throw Exception("Code is no longer active");
    if (loveCode.ownerUid == uid)
      throw Exception("You cannot link with yourself");

    final batch = _firestore.batch();
    final coupleId = 'couple_${loveCode.ownerUid}_$uid';

    // 1. Update current user
    batch.update(_firestore.collection('users').doc(uid), {
      'coupleId': coupleId,
      'isLinked': true,
      'partnerUid': loveCode.ownerUid,
    });

    // 2. Update partner
    batch.update(_firestore.collection('users').doc(loveCode.ownerUid), {
      'coupleId': coupleId,
      'isLinked': true,
      'partnerUid': uid,
    });

    // 3. Create shared relationship doc
    batch.set(_firestore.collection('shared').doc(coupleId), {
      'coupleId': coupleId,
      'uids': [uid, loveCode.ownerUid],
      'anniversary': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 4. Deactivate the code (optional, or mark as used)
    batch.update(_collection.doc(partnerCode), {'isActive': false});

    await batch.commit();
  }
}

@riverpod
LoveCodeRepository loveCodeRepository(LoveCodeRepositoryRef ref) {
  return LoveCodeRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
}
