import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:her/features/mood_garden/domain/garden_element.dart';

part 'garden_state.freezed.dart';
part 'garden_state.g.dart';

@freezed
class GardenState with _$GardenState {
  const factory GardenState({
    required String userId,
    @Default(0) int streak,
    @Default(0) int totalFlowers,
    DateTime? lastLogDate,
    @Default('sunny') String weather,
    @Default({}) Map<String, int> flowerCounts,
  }) = _GardenState;

  factory GardenState.fromJson(Map<String, dynamic> json) =>
      _$GardenStateFromJson(json);

  factory GardenState.empty(String userId) => GardenState(userId: userId);
}

extension GardenStateX on GardenState {
  GardenWeather get currentWeather => switch (weather) {
        'cloudy' => GardenWeather.cloudy,
        'rainy' => GardenWeather.rainy,
        'golden' => GardenWeather.golden,
        _ => GardenWeather.sunny,
      };

  bool get isStreakAlive {
    if (lastLogDate == null) return false;
    return DateTime.now().difference(lastLogDate!).inDays <= 1;
  }
}
