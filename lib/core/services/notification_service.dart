import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

part 'notification_service.g.dart';

@riverpod
NotificationService notificationService(NotificationServiceRef ref) =>
    NotificationService();

// ─── Background FCM handler (top-level, required by firebase_messaging) ────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background messages are handled here
}

// ─── Service ──────────────────────────────────────────────────────────────────

class NotificationService {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static const _channelId = 'luna_channel';
  static const _channelName = 'Luna Reminders';

  // ── Initialization ─────────────────────────────────────────────────────────
  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _local.initialize(
      const InitializationSettings(
          android: androidSettings, iOS: iosSettings),
    );

    // Create Android notification channel
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Soft reminders from Luna 🌸',
      importance: Importance.high,
    );
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // FCM permissions
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground FCM messages → show as local notification
    FirebaseMessaging.onMessage.listen(_showFcmAsLocal);
  }

  // ── FCM Token ──────────────────────────────────────────────────────────────
  Future<String?> getFcmToken() => _fcm.getToken();

  // ── Local Notifications ────────────────────────────────────────────────────
  Future<void> showImmediate({
    required String title,
    required String body,
    int id = 0,
  }) async {
    await _local.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> schedulePeriodReminder({
    required DateTime reminderTime,
    required String userName,
  }) async {
    await _local.zonedSchedule(
      1001,
      'Luna 🌸',
      'Hey $userName, just checking in — how are you feeling today? 💕',
      tz.TZDateTime.from(reminderTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.defaultImportance,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelAll() => _local.cancelAll();
  Future<void> cancel(int id) => _local.cancel(id);

  // ── FCM foreground handler ─────────────────────────────────────────────────
  void _showFcmAsLocal(RemoteMessage message) {
    final n = message.notification;
    if (n == null) return;
    showImmediate(title: n.title ?? 'Luna 🌸', body: n.body ?? '');
  }
}
