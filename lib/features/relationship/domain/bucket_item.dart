import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'bucket_item.freezed.dart';
part 'bucket_item.g.dart';

@freezed
class BucketItem with _$BucketItem {
  const factory BucketItem({
    String? id,
    required String title,
    @Default(false) bool isCompleted,
    required String addedBy,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _BucketItem;

  factory BucketItem.fromJson(Map<String, dynamic> json) => _$BucketItemFromJson(json);

  factory BucketItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BucketItem.fromJson({
      ...data,
      'id': doc.id,
      'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
      'completedAt': data['completedAt'] != null ? (data['completedAt'] as Timestamp).toDate().toIso8601String() : null,
    });
  }
}
