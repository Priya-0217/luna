import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/features/insights/data/insights_repository.dart';
import 'package:her/features/insights/domain/insight.dart';
import 'package:her/features/insights/domain/wellness_trend.dart';

part 'insights_provider.g.dart';

@riverpod
Future<List<WellnessTrend>> wellnessTrends(
    WellnessTrendsRef ref, {int days = 30}) async {
  return ref.watch(insightsRepositoryProvider).getTrends(days: days);
}

@riverpod
Future<List<Insight>> generatedInsights(GeneratedInsightsRef ref) async {
  return ref.watch(insightsRepositoryProvider).generateInsights();
}
