import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:her/features/relationship/data/relationship_repository.dart';
import 'package:her/features/relationship/domain/memory.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'memory_service.g.dart';

@riverpod
MemoryService memoryService(MemoryServiceRef ref) {
  return MemoryService(
    ref.watch(relationshipRepositoryProvider),
    FirebaseStorage.instance,
  );
}

class MemoryService {
  final RelationshipRepository _repository;
  final FirebaseStorage _storage;
  final _uuid = const Uuid();

  MemoryService(this._repository, this._storage);

  Future<void> createMemory({
    required String coupleId,
    required String title,
    String? description,
    required File imageFile,
    required String userId,
  }) async {
    // 1. Upload image to Storage
    final fileName = '${_uuid.v4()}.jpg';
    final ref = _storage.ref().child('shared/$coupleId/memories/$fileName');
    await ref.putFile(imageFile);
    final imageUrl = await ref.getDownloadURL();

    // 2. Create memory document
    final memory = Memory(
      title: title,
      description: description,
      imageUrl: imageUrl,
      addedBy: userId,
      createdAt: DateTime.now(),
    );

    await _repository.addMemory(coupleId, memory);
  }
}
