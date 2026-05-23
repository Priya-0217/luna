import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

@riverpod
AnalyticsService analyticsService(AnalyticsServiceRef ref) =>
    AnalyticsService(FirebaseAnalytics.instance);

class AnalyticsService {
  AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> logLogin() =>
      _analytics.logLogin(loginMethod: 'email');

  Future<void> logSignup() =>
      _analytics.logSignUp(signUpMethod: 'email');

  Future<void> logDailyLogSaved() =>
      _analytics.logEvent(name: 'daily_log_saved');

  Future<void> logCycleStarted() =>
      _analytics.logEvent(name: 'cycle_started');

  Future<void> logJournalWritten() =>
      _analytics.logEvent(name: 'journal_written');

  Future<void> logFromHimOpened(String triggerId) =>
      _analytics.logEvent(name: 'from_him_opened', parameters: {
        'trigger_id': triggerId,
      });

  Future<void> logGardenViewed() =>
      _analytics.logEvent(name: 'garden_viewed');

  Future<void> logCompanionChatStarted() =>
      _analytics.logEvent(name: 'companion_chat_started');

  Future<void> setUserId(String uid) => _analytics.setUserId(id: uid);
}
