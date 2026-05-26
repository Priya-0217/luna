import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'memory.freezed.dart';
part 'memory.g.dart';

@freezed
class Memory with _$Memory {
  const factory Memory({
    String? id,
    required String title,
    String? description,
    required String imageUrl,
    required String addedBy,
    required DateTime createdAt,
    @Default([]) List<String> reactions,
  }) = _Memory;

  factory Memory.fromJson(Map<String, dynamic> json) => _$MemoryFromJson(json);

  factory Memory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Memory.fromJson({
      ...data,
      'id': doc.id,
      'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
    });
  }
}
