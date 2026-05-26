import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/features/relationship/domain/memory.dart';
import 'package:her/features/relationship/domain/bucket_item.dart';

part 'relationship_repository.g.dart';

class RelationshipRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  RelationshipRepository(this._firestore, this._auth);

  Stream<Map<String, dynamic>?> watchRelationship(String coupleId) {
    return _firestore
        .collection('shared')
        .doc(coupleId)
        .snapshots()
        .map((doc) => doc.data());
  }

  Future<void> updateRelationship(
    String coupleId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection('shared').doc(coupleId).update(data);
  }

  Future<void> updateLastPing(String coupleId, String fromUserId) async {
    await _firestore.collection('shared').doc(coupleId).update({
      'lastPingFrom': fromUserId,
      'lastPingAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Memory>> watchMemories(String coupleId) {
    return _firestore
        .collection('shared')
        .doc(coupleId)
        .collection('memories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Memory.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addMemory(String coupleId, Memory memory) async {
    await _firestore
        .collection('shared')
        .doc(coupleId)
        .collection('memories')
        .add({
          ...memory.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
          'addedBy': _auth.currentUser?.uid,
        });
  }

  Stream<List<BucketItem>> watchBucketList(String coupleId) {
    return _firestore
        .collection('shared')
        .doc(coupleId)
        .collection('bucketList')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BucketItem.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> addBucketItem(String coupleId, String title) async {
    await _firestore
        .collection('shared')
        .doc(coupleId)
        .collection('bucketList')
        .add({
          'title': title,
          'isCompleted': false,
          'createdAt': FieldValue.serverTimestamp(),
          'addedBy': _auth.currentUser?.uid,
        });
  }

  Future<void> toggleBucketItem(
    String coupleId,
    String itemId,
    bool isCompleted,
  ) async {
    await _firestore
        .collection('shared')
        .doc(coupleId)
        .collection('bucketList')
        .doc(itemId)
        .update({
          'isCompleted': isCompleted,
          if (isCompleted) 'completedAt': FieldValue.serverTimestamp(),
          if (!isCompleted) 'completedAt': null,
        });
  }
}

@riverpod
RelationshipRepository relationshipRepository(RelationshipRepositoryRef ref) {
  return RelationshipRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
}
