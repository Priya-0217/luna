import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_log_entry.freezed.dart';
part 'daily_log_entry.g.dart';

@freezed
class DailyLogEntry with _$DailyLogEntry {
  const factory DailyLogEntry({
    required String id,
    required String userId,
    required DateTime date,
    required String mood,
    @Default(0) int flowLevel,
    @Default([]) List<String> symptoms,
    String? notes,
    @Default(3) int energyLevel,
    @Default(false) bool synced,
  }) = _DailyLogEntry;

  factory DailyLogEntry.fromJson(Map<String, dynamic> json) =>
      _$DailyLogEntryFromJson(json);
}
