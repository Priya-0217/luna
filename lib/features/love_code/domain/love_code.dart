import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'love_code.freezed.dart';
part 'love_code.g.dart';

@freezed
class LoveCode with _$LoveCode {
  const factory LoveCode({
    required String code,
    required String ownerUid,
    required String ownerRole,
    required String ownerName,
    String? linkedUid,
    @TimestampConverter() DateTime? linkedAt,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime expiresAt,
    @Default(true) bool isActive,
  }) = _LoveCode;

  factory LoveCode.fromJson(Map<String, dynamic> json) =>
      _$LoveCodeFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
