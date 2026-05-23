import 'package:freezed_annotation/freezed_annotation.dart';

part 'cycle_entry.freezed.dart';
part 'cycle_entry.g.dart';

@freezed
class CycleEntry with _$CycleEntry {
  const factory CycleEntry({
    required String id,
    required String userId,
    required DateTime startDate,
    DateTime? endDate,
    int? cycleLength,
    @Default(false) bool synced,
    required DateTime createdAt,
  }) = _CycleEntry;

  factory CycleEntry.fromJson(Map<String, dynamic> json) =>
      _$CycleEntryFromJson(json);
}
