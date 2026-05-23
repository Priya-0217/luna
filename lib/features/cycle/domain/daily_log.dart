import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_log.freezed.dart';
part 'daily_log.g.dart';

@freezed
class DailyLog with _$DailyLog {
  const factory DailyLog({
    required String id,
    required String userId,
    required DateTime date,
    required String mood,
    required int flow,
    required String symptoms,
    String? notes,
    required int energyLevel,
    @Default(false) bool synced,
    required DateTime createdAt,
  }) = _DailyLog;

  factory DailyLog.fromJson(Map<String, dynamic> json) =>
      _$DailyLogFromJson(json);
}
