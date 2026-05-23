/// A single data point for chart rendering in the Insights screen.
class WellnessTrend {
  const WellnessTrend({
    required this.date,
    required this.moodScore,
    required this.energyScore,
    required this.flowLevel,
    required this.hydrationMl,
    required this.sleepHours,
  });

  final DateTime date;
  final double moodScore;   // 0.0–1.0
  final double energyScore; // 0.0–1.0
  final int flowLevel;      // 0–5
  final double hydrationMl;
  final double sleepHours;

  /// Derives a mood score from a mood string.
  static double moodToScore(String mood) => switch (mood) {
        'joyful' => 1.0,
        'excited' => 0.95,
        'grateful' => 0.9,
        'content' => 0.8,
        'calm' => 0.75,
        'cozy' => 0.7,
        'tired' => 0.4,
        'anxious' => 0.35,
        'stressed' => 0.3,
        'irritable' => 0.25,
        'sad' => 0.2,
        'crying' => 0.1,
        _ => 0.5,
      };
}

enum InsightType { moodPattern, cycleRegularity, sleepQuality, hydrationStreak, symptomFrequency }
