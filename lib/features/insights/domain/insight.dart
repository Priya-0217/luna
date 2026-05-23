import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:her/features/insights/domain/wellness_trend.dart';

part 'insight.freezed.dart';
part 'insight.g.dart';

@freezed
class Insight with _$Insight {
  const factory Insight({
    required String id,
    required String title,
    required String body,
    required String type,
    required DateTime generatedAt,
    @Default(false) bool isRead,
  }) = _Insight;

  factory Insight.fromJson(Map<String, dynamic> json) =>
      _$InsightFromJson(json);
}

extension InsightX on Insight {
  InsightType get insightType {
    try {
      return InsightType.values.firstWhere((t) => t.name == type);
    } catch (_) {
      return InsightType.moodPattern;
    }
  }
}
