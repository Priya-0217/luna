import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_log.freezed.dart';
part 'sleep_log.g.dart';

@freezed
class SleepLog with _$SleepLog {
  const factory SleepLog({
    required String id,
    required String userId,
    required double hours,
    required DateTime date,
    @Default(3) int quality,
    @Default(false) bool synced,
  }) = _SleepLog;

  factory SleepLog.fromJson(Map<String, dynamic> json) =>
      _$SleepLogFromJson(json);
}
