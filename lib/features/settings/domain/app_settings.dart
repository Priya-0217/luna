import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required String userId,
    @Default(28) int cycleLength,
    @Default(5) int periodLength,
    @Default(true) bool notificationsEnabled,
    @Default(false) bool disguiseMode,
    @Default('08:00') String reminderTime,
    DateTime? lastSynced,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  factory AppSettings.defaults(String userId) => AppSettings(userId: userId);
}
