import 'package:freezed_annotation/freezed_annotation.dart';

part 'love_message.freezed.dart';
part 'love_message.g.dart';

@freezed
class LoveMessage with _$LoveMessage {
  const factory LoveMessage({
    required String id,
    required String title,
    required String body,
    required String triggerId,
    @Default(false) bool isUnlocked,
    DateTime? unlockedAt,
    @Default('letter') String type,
    required DateTime createdAt,
  }) = _LoveMessage;

  factory LoveMessage.fromJson(Map<String, dynamic> json) =>
      _$LoveMessageFromJson(json);
}
