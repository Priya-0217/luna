import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Route constant imports
import 'package:her/core/router/app_routes.dart';

// Feature presentation imports
import 'package:her/features/auth/presentation/login_screen.dart';
import 'package:her/features/auth/presentation/signup_screen.dart';
import 'package:her/features/onboarding/presentation/onboarding_screen.dart';
import 'package:her/features/home/presentation/home_screen.dart';
import 'package:her/features/cycle/presentation/cycle_screen.dart';
import 'package:her/features/mood_garden/presentation/mood_garden_screen.dart';
import 'package:her/features/from_him/presentation/from_him_screen.dart';
import 'package:her/features/settings/presentation/profile_tab.dart';

// Details presentation imports
import 'package:her/features/daily_log/presentation/daily_log_screen.dart';
import 'package:her/features/from_him/presentation/envelope_open_screen.dart';
import 'package:her/features/journal/domain/journal_entry.dart';
import 'package:her/features/from_him/presentation/memory_gallery_screen.dart';
import 'package:her/features/from_him/presentation/comfort_playlist_screen.dart';
import 'package:her/features/from_him/presentation/voice_playback_screen.dart';
import 'package:her/features/journal/presentation/journal_screen.dart';
import 'package:her/features/journal/presentation/journal_write_screen.dart';
import 'package:her/features/mood_garden/presentation/companion_screen.dart';
import 'package:her/features/insights/presentation/insights_screen.dart';
import 'package:her/features/self_care/presentation/self_care_screen.dart';
import 'package:her/features/settings/presentation/settings_screen.dart';
import 'package:her/features/settings/presentation/app_lock_screen.dart';

// Auth provider import
import 'package:her/features/auth/providers/auth_provider.dart';

// Root navigation key
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterHelperProvider = Provider<GoRouter>((ref) {
  // Use a Listenable that triggers when auth state changes
  // We don't watch authProvider directly here to avoid rebuilding the GoRouter object
  // which causes GlobalKey conflicts.
  final authNotifier = ref.read(authProvider.notifier);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    refreshListenable: _AuthListenable(ref),
    // Redirect logic: If logged in, redirect away from auth screens
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final user = authState.valueOrNull;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (user == null) {
        // Force login if trying to access secure routes
        if (!isLoggingIn && state.matchedLocation != '/onboarding') {
          return '/login';
        }
      } else {
        // If user is not onboarded and not currently on the onboarding screen, force them there
        if (!user.isOnboarded && state.matchedLocation != '/onboarding') {
          return '/onboarding';
        }
        
        // If logged in, onboarded, and on auth/onboarding pages, go to dashboard
        if (user.isOnboarded && (isLoggingIn || state.matchedLocation == '/onboarding')) {
          return '/';
        }
      }
      return null;
    },
    routes: [
      // Authentication
      GoRoute(
        path: '/login',
        name: AppRoutes.login,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: AppRoutes.signup,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SignupScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: AppRoutes.onboarding,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Shell tabs navigation structure
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: AppRoutes.home,
            builder: (context, state) => const HomeTab(),
          ),
          GoRoute(
            path: '/cycle',
            name: AppRoutes.cycle,
            builder: (context, state) => const CycleScreen(),
          ),
          GoRoute(
            path: '/garden',
            name: AppRoutes.garden,
            builder: (context, state) => const MoodGardenScreen(),
          ),
          GoRoute(
            path: '/from-him',
            name: AppRoutes.fromHim,
            builder: (context, state) => const FromHimScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: AppRoutes.profile,
            builder: (context, state) => const ProfileTab(),
          ),
        ],
      ),

      // Detailed views stacked on top of tabs (root navigator)
      GoRoute(
        path: '/daily-log',
        name: AppRoutes.dailyLog,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const DailyLogScreen(),
      ),
      GoRoute(
        path: '/envelope/:id',
        name: AppRoutes.envelope,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'unknown';
          return EnvelopeOpenScreen(letterId: id);
        },
      ),
      GoRoute(
        path: '/memories',
        name: AppRoutes.memoryGallery,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const MemoryGalleryScreen(),
      ),
      GoRoute(
        path: '/playlist',
        name: AppRoutes.playlist,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ComfortPlaylistScreen(),
      ),
      GoRoute(
        path: '/voice-note',
        name: AppRoutes.voicePlayback,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const VoicePlaybackScreen(),
      ),
      GoRoute(
        path: '/journal',
        name: AppRoutes.journal,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const JournalScreen(),
      ),
      GoRoute(
        path: '/journal/write',
        name: AppRoutes.journalWrite,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final entry = state.extra as JournalEntry?;
          return JournalWriteScreen(existingEntry: entry);
        },
      ),
      GoRoute(
        path: '/companion',
        name: AppRoutes.companion,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CompanionScreen(),
      ),
      GoRoute(
        path: '/insights',
        name: AppRoutes.insights,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/self-care',
        name: AppRoutes.selfCare,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SelfCareScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: AppRoutes.settings,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/security',
        name: AppRoutes.appLock,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AppLockScreen(),
      ),
    ],
  );
});

/// A simple Listenable that notifies GoRouter when the Auth state changes.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    _subscription = ref.listen(authProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  late final ProviderSubscription _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
