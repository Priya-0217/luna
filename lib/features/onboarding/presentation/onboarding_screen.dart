import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/floating_particles.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/router/app_routes.dart';
import 'package:her/core/role/app_role.dart';

import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/auth/domain/app_user.dart';
import 'package:her/features/cycle/data/cycle_repository.dart';
import 'package:her/features/home/providers/dashboard_provider.dart';

import 'pages/splash_page.dart';
import 'pages/role_select_page.dart';
import 'pages/her_name_page.dart';
import 'pages/cycle_setup_page.dart';
import 'pages/love_code_page.dart';
import 'pages/her_notifications_page.dart';
import 'pages/him_name_page.dart';
import 'pages/him_about_her_page.dart';
import 'pages/him_notifications_page.dart';
import 'pages/ready_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Shared State
  AppRole? _selectedRole;
  String _loveCode = '';

  // Her State
  final _herNameController = TextEditingController();
  double _cycleLength = 28.0;
  double _periodDuration = 5.0;
  DateTime _lastPeriodDate = DateTime.now().subtract(const Duration(days: 10));
  Map<String, bool> _herNotifications = {
    'period': true,
    'hydration': true,
    'sleep': false,
    'fromHim': true,
    'dailyLog': true,
  };

  // Him State
  final _himNameController = TextEditingController();
  final _herNameForHimController = TextEditingController();
  final _secretNoteController = TextEditingController();
  Map<String, bool> _himPreferences = {
    'shareCycle': false,
    'herNotifications': false,
    'privateReminders': true,
  };
  Map<String, bool> _himNotifications = {
    'period': true,
    'mood': true,
    'fromHer': true,
    'care': true,
    'streak': true,
  };

  @override
  void dispose() {
    _pageController.dispose();
    _herNameController.dispose();
    _himNameController.dispose();
    _herNameForHimController.dispose();
    _secretNoteController.dispose();
    super.dispose();
  }

  void _generateLoveCodeIfNeeded() {
    if (_loveCode.isNotEmpty || _selectedRole == null) return;
    
    final w1Her = ['ROSE', 'DAWN', 'SOFT', 'SILK', 'PETAL', 'BLUSH'];
    final w2Her = ['MOON', 'MIST', 'GLOW', 'HAZE', 'LACE', 'DUSK'];
    final w1Him = ['STAR', 'WAVE', 'PINE', 'STORM', 'FORGE', 'TIDE'];
    final w2Him = ['TIDE', 'CREST', 'PEAK', 'VALE', 'COVE', 'BLAZE'];

    final w1 = _selectedRole == AppRole.her ? w1Her : w1Him;
    final w2 = _selectedRole == AppRole.her ? w2Her : w2Him;
    
    final r = Random();
    final word1 = w1[r.nextInt(w1.length)];
    final word2 = w2[r.nextInt(w2.length)];
    final digits = r.nextInt(9000) + 1000;
    
    setState(() {
      _loveCode = 'LUNA-$word1-$word2-$digits';
    });
  }

  List<Widget> get _pages {
    final pages = <Widget>[
      SplashPage(
        onBegin: _nextPage,
        onConnect: () {
          context.pushNamed(AppRoutes.codeEntry);
        },
      ),
      RoleSelectPage(
        selectedRole: _selectedRole?.name,
        onRoleSelected: (roleStr) {
          setState(() {
            _selectedRole = roleStr == 'her' ? AppRole.her : AppRole.him;
          });
          _generateLoveCodeIfNeeded();
          _nextPage();
        },
      ),
    ];

    if (_selectedRole == AppRole.her) {
      pages.addAll([
        HerNamePage(controller: _herNameController, onNext: _nextPage),
        CycleSetupPage(
          lastPeriodDate: _lastPeriodDate,
          cycleLength: _cycleLength,
          periodDuration: _periodDuration,
          onDateSelected: (d) => setState(() => _lastPeriodDate = d),
          onCycleLengthChanged: (v) => setState(() => _cycleLength = v),
          onPeriodDurationChanged: (v) => setState(() => _periodDuration = v),
        ),
        LoveCodePage(
          role: 'her',
          code: _loveCode,
          onCopy: () {
            Clipboard.setData(ClipboardData(text: _loveCode));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied! Send it to him 💙')),
            );
          },
          onShare: () {}, // TODO: Native share
          onQR: () {}, // TODO: Show QR sheet
          onSkip: _nextPage,
        ),
        HerNotificationsPage(
          selections: _herNotifications,
          onChanged: (k, v) => setState(() => _herNotifications[k] = v),
        ),
        HerReadyPage(onFinish: _finishOnboarding),
      ]);
    } else if (_selectedRole == AppRole.him) {
      pages.addAll([
        SplashPage(
          isHim: true,
          onBegin: _nextPage,
          onConnect: () {
            context.pushNamed(AppRoutes.codeEntry);
          },
        ),
        HimNamePage(
          hisNameController: _himNameController,
          herNameController: _herNameForHimController,
          onNext: _nextPage,
        ),
        HimAboutHerPage(
          preferences: _himPreferences,
          onPreferenceChanged: (k, v) => setState(() => _himPreferences[k] = v),
          secretNoteController: _secretNoteController,
        ),
        LoveCodePage(
          role: 'him',
          code: _loveCode,
          onCopy: () {
            Clipboard.setData(ClipboardData(text: _loveCode));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied! Send it to her 🌸')),
            );
          },
          onShare: () {}, // TODO: Native share
          onQR: () {}, // TODO: Show QR sheet
          onSkip: _nextPage,
          onEnterPartnerCode: () {
            context.pushNamed(AppRoutes.codeEntry);
          },
        ),
        HimNotificationsPage(
          selections: _himNotifications,
          onChanged: (k, v) => setState(() => _himNotifications[k] = v),
        ),
        HimReadyPage(onFinish: _finishOnboarding),
      ]);
    }

    return pages;
  }

  void _nextPage() {
    if (_currentPage == 1 && _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select who you are to continue ✨')),
      );
      return;
    }

    if (_currentPage < _pages.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    HapticFeedback.mediumImpact();

    final isHer = _selectedRole == AppRole.her;
    final name = isHer ? _herNameController.text.trim() : _himNameController.text.trim();
    
    // Save to Hive
    final box = Hive.box('settings');
    await box.putAll({
      'onboarding_completed': true,
      'app_role': _selectedRole?.name,
      'username': name,
    });

    if (isHer) {
      await box.putAll({
        'cycle_length': _cycleLength.toInt(),
        'period_duration': _periodDuration.toInt(),
        'last_period_date': _lastPeriodDate.toIso8601String(),
        'notifications_enabled': _herNotifications['period'] ?? true,
      });
    } else {
      await box.putAll({
        'her_name': _herNameForHimController.text.trim(),
        'him_secret_note': _secretNoteController.text.trim(),
      });
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final authNotifier = ref.read(authProvider.notifier);
      final appUser = ref.read(authProvider).valueOrNull ?? AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: name,
        isOnboarded: false,
      );

      try {
        // Save Love Code locally & to Firestore
        try {
          await FirebaseFirestore.instance.collection('loveCodes').doc(_loveCode).set({
            'code': _loveCode,
            'ownerUid': firebaseUser.uid,
            'ownerRole': _selectedRole?.name,
            'ownerName': name,
            'linkedUid': null,
            'linkedAt': null,
            'createdAt': FieldValue.serverTimestamp(),
            'isActive': true,
          });
        } catch (e) {
          debugPrint('Warning: Could not save loveCode document to Firestore: $e');
        }

        // Update User Profile
        await authNotifier.updateProfile(appUser.copyWith(
          displayName: name,
          role: _selectedRole?.name,
          myLoveCode: _loveCode,
          isOnboarded: true,
          cycleAverageLength: isHer ? _cycleLength.toInt() : 28,
          periodAverageLength: isHer ? _periodDuration.toInt() : 5,
        ));

        if (isHer) {
          final cycleRepo = ref.read(cycleRepositoryProvider);
          await cycleRepo.startPeriod(_lastPeriodDate);
          ref.invalidate(dashboardProvider);
        }

        if (mounted) context.goNamed(AppRoutes.home);
      } catch (e) {
        debugPrint('Error during onboarding completion: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save your details: $e')),
          );
        }
      }
    } else {
      if (mounted) context.goNamed(AppRoutes.signup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHim = _selectedRole == AppRole.him;
    final pages = _pages;
    
    // Determine if we show bottom nav on this page
    // Splash pages (0, and potentially 2 if Him) usually have their own buttons
    // Ready pages (last) have their own finish buttons
    bool showBottomNav = _currentPage > 0 && _currentPage < pages.length - 1;
    if (isHim && _currentPage == 2) showBottomNav = false; // Him Splash

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.ivory,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isHim
                    ? [AppColors.slateBlue, AppColors.slateBlueSoft, AppColors.ivory]
                    : [AppColors.roseDark, AppColors.roseSoft, AppColors.ivory],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          FloatingParticles(
            count: 20,
            color: isHim ? AppColors.slateBluePrimary.withOpacity(0.3) : AppColors.rosePrimary.withOpacity(0.3),
          ),
          SafeArea(
            child: Column(
              children: [
                // Minimal Progress Indicator
                if (_currentPage > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                    child: Row(
                      children: List.generate(pages.length - 1, (index) {
                        final active = index < _currentPage;
                        return Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            height: 3,
                            decoration: BoxDecoration(
                              color: active
                                  ? (isHim ? AppColors.slateBluePrimary : AppColors.rosePrimary)
                                  : (isDark ? AppColors.darkBorder : AppColors.warmGray200),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                // Active slide body
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                    },
                    children: pages,
                  ),
                ),

                // Bottom Nav buttons
                if (showBottomNav)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _prevPage,
                          child: Text(
                            'Back',
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark ? AppColors.warmGray400 : AppColors.charcoal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        LunaButton(
                          text: 'Continue',
                          width: 160,
                          backgroundColor: isHim ? AppColors.slateBluePrimary : AppColors.rosePrimary,
                          onPressed: _nextPage,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
