import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:her/core/services/database.dart';
import 'package:her/core/services/firestore_service.dart';
import 'package:her/features/mood_garden/domain/chat_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;

part 'chat_repository.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) => ChatRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(firestoreServiceProvider),
    );

class ChatRepository {
  ChatRepository(this._db, this._firestore);

  final AppDatabase _db;
  final FirestoreService _firestore;
  final _uuid = const Uuid();

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> saveMessage(ChatMessage message) async {
    // 1. Save locally to Drift (Assuming we add a chat_messages table)
    // For now, let's just save to Firestore for real-time sync as requested.
    
    final userDoc = FirebaseFirestore.instance.collection('users').doc(_uid);
    await userDoc.collection('gardenChat').doc(message.id).set({
      'content': message.content,
      'role': message.role.name,
      'timestamp': Timestamp.fromDate(message.timestamp),
      'isError': message.isError,
    });
  }

  Stream<List<ChatMessage>> watchMessages() {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(_uid);
    return userDoc
        .collection('gardenChat')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessage(
          id: doc.id,
          content: data['content'] ?? '',
          role: MessageRole.values.firstWhere(
            (r) => r.name == data['role'],
            orElse: () => MessageRole.assistant,
          ),
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          isError: data['isError'] ?? false,
        );
      }).toList().reversed.toList();
    });
  }

  Future<void> clearHistory() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(_uid);
    final messages = await userDoc.collection('gardenChat').get();
    final batch = FirebaseFirestore.instance.batch();
    for (var doc in messages.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
