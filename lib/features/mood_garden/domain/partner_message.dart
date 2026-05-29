import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_message.freezed.dart';
part 'partner_message.g.dart';

@freezed
class PartnerMessage with _$PartnerMessage {
  const PartnerMessage._();

  const factory PartnerMessage({
    required String id,
    required String senderId,
    required String senderName,
    String? content,
    String? illustrationKey,
    required DateTime timestamp,
    String? replyToId,
    String? replyToText,
    String? replyToSenderName,
    String? replyToIllustrationKey,
    @Default({}) Map<String, dynamic> reactions,
    @Default({}) Map<String, dynamic> metadata,
  }) = _PartnerMessage;

  factory PartnerMessage.fromJson(Map<String, dynamic> json) =>
      _$PartnerMessageFromJson(json);

  Map<String, List<String>> get typedReactions {
    final Map<String, List<String>> result = {};
    reactions.forEach((key, value) {
      if (value is List) {
        result[key] = value.map((e) => e.toString()).toList();
      }
    });
    return result;
  }
}
