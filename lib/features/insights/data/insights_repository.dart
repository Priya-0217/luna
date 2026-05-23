import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/core/services/database.dart';
import 'package:her/core/services/sync_service.dart';
import 'package:her/features/insights/domain/insight.dart';
import 'package:her/features/insights/domain/wellness_trend.dart';

part 'insights_repository.g.dart';

@riverpod
InsightsRepository insightsRepository(InsightsRepositoryRef ref) =>
    InsightsRepository(ref.watch(appDatabaseProvider));

class InsightsRepository {
  InsightsRepository(this._db);

  final AppDatabase _db;

  /// Returns trend data for the last [days] days.
  Future<List<WellnessTrend>> getTrends({int days = 30}) async {
    final from = DateTime.now().subtract(Duration(days: days));
    final logs = await _db.getLogsInRange(from, DateTime.now());

    return logs.map((log) {
      final hydration = 0.0; // Would cross-reference SelfCareLogs by date
      return WellnessTrend(
        date: log.date,
        moodScore: WellnessTrend.moodToScore(log.mood),
        energyScore: log.energyLevel / 5.0,
        flowLevel: log.flow,
        hydrationMl: hydration,
        sleepHours: 0.0,
      );
    }).toList();
  }

  /// Generates insight cards based on recent data.
  Future<List<Insight>> generateInsights() async {
    final trends = await getTrends(days: 30);
    final insights = <Insight>[];
    final now = DateTime.now();

    if (trends.isNotEmpty) {
      final avgMood =
          trends.map((t) => t.moodScore).reduce((a, b) => a + b) /
              trends.length;

      if (avgMood > 0.7) {
        insights.add(Insight(
          id: 'mood_positive',
          title: 'Your mood is shining ✨',
          body: "You've been feeling ${(avgMood * 100).toInt()}% positive this month. He'd be so proud of you.",
          type: InsightType.moodPattern.name,
          generatedAt: now,
        ));
      } else if (avgMood < 0.4) {
        insights.add(Insight(
          id: 'mood_check',
          title: 'Sending you extra love 💕',
          body: "It looks like you've had some tough days lately. Remember, it's okay to rest and feel all the feels.",
          type: InsightType.moodPattern.name,
          generatedAt: now,
        ));
      }

      if (trends.length >= 7) {
        insights.add(Insight(
          id: 'streak',
          title: '${trends.length} days of logging 🌸',
          body: "You've been showing up for yourself every day. That consistency is beautiful.",
          type: InsightType.cycleRegularity.name,
          generatedAt: now,
        ));
      }
    }

    return insights;
  }
}
