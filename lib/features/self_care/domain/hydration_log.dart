import 'package:freezed_annotation/freezed_annotation.dart';

part 'hydration_log.freezed.dart';
part 'hydration_log.g.dart';

@freezed
class HydrationLog with _$HydrationLog {
  const factory HydrationLog({
    required String id,
    required String userId,
    required double amountMl,
    required DateTime timestamp,
    @Default(false) bool synced,
  }) = _HydrationLog;

  factory HydrationLog.fromJson(Map<String, dynamic> json) =>
      _$HydrationLogFromJson(json);
}
