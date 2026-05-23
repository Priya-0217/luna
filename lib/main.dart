import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:her/app.dart';
import 'package:her/core/services/notification_service.dart';
import 'package:her/core/services/sync_service.dart';
import 'package:her/core/services/database.dart';
import 'package:her/core/services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // Hive for local settings cache
  try {
    await Hive.initFlutter();
    await Hive.openBox('settings');
  } catch (e) {
    debugPrint('Hive initialization warning: $e');
  }

  // Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized 🌸');
  } catch (e) {
    debugPrint('Firebase offline-first mode active 🌙 ($e)');
  }

  // Local + FCM notifications
  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('Notification init warning: $e');
  }

  // Create a temporary ProviderContainer to wire up sync on startup
  final container = ProviderContainer();
  try {
    final syncService = container.read(syncServiceProvider);
    syncService.listenForConnectivity();
    // Sync pending writes from previous offline sessions
    syncService.syncAllPending();
  } catch (e) {
    debugPrint('Sync init warning: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LunaApp(),
    ),
  );
}
