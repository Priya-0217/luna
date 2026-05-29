import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:her/features/mood_garden/domain/partner_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'partner_chat_repository.g.dart';

@riverpod
PartnerChatRepository partnerChatRepository(PartnerChatRepositoryRef ref) {
  return PartnerChatRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
}

class PartnerChatRepository {
  PartnerChatRepository(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _messagesCollection(String coupleId) {
    return _firestore
        .collection('shared')
        .doc(coupleId)
        .collection('partnerChat');
  }

  Stream<List<PartnerMessage>> watchMessages(String coupleId) {
    return _messagesCollection(coupleId)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PartnerMessage.fromJson({
          ...data,
          'id': doc.id,
          'timestamp': (data['timestamp'] as Timestamp).toDate().toIso8601String(),
        });
      }).toList().reversed.toList();
    });
  }

  Future<void> sendMessage(String coupleId, PartnerMessage message) async {
    final data = message.toJson();
    data['timestamp'] = Timestamp.fromDate(message.timestamp);
    await _messagesCollection(coupleId).doc(message.id).set(data);
  }

  Future<void> reactToMessage({
    required String coupleId,
    required String messageId,
    required String emoji,
    required String userId,
  }) async {
    final docRef = _messagesCollection(coupleId).doc(messageId);
    
    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) return;

      final data = doc.data() ?? {};
      final reactionsMap = Map<String, dynamic>.from(data['reactions'] ?? {});
      final List<dynamic> usersList = List<dynamic>.from(reactionsMap[emoji] ?? []);

      if (usersList.contains(userId)) {
        usersList.remove(userId);
      } else {
        usersList.add(userId);
      }

      if (usersList.isEmpty) {
        reactionsMap.remove(emoji);
      } else {
        reactionsMap[emoji] = usersList;
      }

      transaction.update(docRef, {'reactions': reactionsMap});
    });
  }

  Future<void> clearHistory(String coupleId) async {
    final messages = await _messagesCollection(coupleId).get();
    final batch = _firestore.batch();
    for (var doc in messages.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
