import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/features/home/providers/dashboard_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/animated_gradient_bg.dart';
import 'package:her/core/widgets/floating_particles.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/router/app_routes.dart';
import 'package:her/features/home/domain/cycle_phase.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/auth/data/auth_repository.dart';
import 'package:her/features/auth/domain/app_user.dart';
import 'package:her/features/cycle/data/cycle_repository.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form states
  final _nameController = TextEditingController();
  double _cycleLength = 28.0;
  double _periodDuration = 5.0;
  DateTime _lastPeriodDate = DateTime.now().subtract(const Duration(days: 10));
  bool _notificationsEnabled = true;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
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

  void _finishOnboarding() async {
    // 1. Validation
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _pageController.animateToPage(1,
          duration: const Duration(milliseconds: 400), curve: Curves.ease);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name 💕')),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    // 2. Local caching
    final box = Hive.box('settings');
    debugPrint('Onboarding: Saving to Hive: name=$name, cycle=$_cycleLength, period=$_periodDuration, date=$_lastPeriodDate');
    await box.putAll({
      'onboarding_completed': true,
      'username': name,
      'cycle_length': _cycleLength.toInt(),
      'period_duration': _periodDuration.toInt(),
      'last_period_date': _lastPeriodDate.toIso8601String(),
      'notifications_enabled': _notificationsEnabled,
    });

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final authNotifier = ref.read(authProvider.notifier);
      final cycleRepo = ref.read(cycleRepositoryProvider);

      final appUser = ref.read(authProvider).valueOrNull ??
          AppUser(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            displayName: name,
            cycleAverageLength: _cycleLength.toInt(),
            periodAverageLength: _periodDuration.toInt(),
            isOnboarded: false,
          );

      try {
        // 3. Update Firebase Profile
        await authNotifier.updateProfile(appUser.copyWith(
          displayName: name,
          cycleAverageLength: _cycleLength.toInt(),
          periodAverageLength: _periodDuration.toInt(),
          isOnboarded: true,
        ));

        // 4. Start first period entry
        await cycleRepo.startPeriod(_lastPeriodDate);

        // Force a refresh of the dashboard to ensure the first calculation is correct
        ref.invalidate(dashboardProvider);

        if (mounted) {
          context.goNamed(AppRoutes.home);
        }
      } catch (e) {
        debugPrint('Error during onboarding completion: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save your details: $e')),
          );
        }
      }
    } else {
      // Send the user to signup
      if (mounted) {
        context.goNamed(AppRoutes.signup);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastPeriodDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.rosePrimary,
              onPrimary: AppColors.white,
              onSurface: AppColors.roseDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _lastPeriodDate) {
      setState(() {
        _lastPeriodDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      body: AnimatedGradientBackground(
        phase: CyclePhase.follicular,
        child: FloatingParticles(
          child: SafeArea(
            child: Column(
              children: [
                // Top Progress indicator
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: List.generate(5, (index) {
                      final active = index <= _currentPage;
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.rosePrimary
                                : (isDark ? AppColors.darkBorder : AppColors.roseMid.withOpacity(0.3)),
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
                    children: [
                      _buildWelcomeSlide(isDark),
                      _buildNameSlide(isDark),
                      _buildCycleSlide(isDark),
                      _buildNotifySlide(isDark),
                      _buildEnvelopeSlide(isDark),
                    ],
                  ),
                ),

                // Bottom Nav buttons
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        TextButton(
                          onPressed: _prevPage,
                          child: Text(
                            'Back',
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark ? AppColors.warmGray400 : AppColors.roseDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      LunaButton(
                        text: _currentPage == 4 ? 'Enter Luna 💕' : 'Continue',
                        width: 160,
                        onPressed: _nextPage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // === SLIDE BUILDERS ===

  Widget _buildWelcomeSlide(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          // Hello character — large, clean, centered
          Image.asset(
            AppIllustrations.hello,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                color: AppColors.roseSoft,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('🌙', style: TextStyle(fontSize: 80)),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Hello, Beautiful 🌸',
            textAlign: TextAlign.center,
            style: AppTypography.displayLarge.copyWith(
              color: isDark ? AppColors.darkText : AppColors.roseDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Welcome to Luna — a custom, quiet space he built just for you. Every element, card, and note has been filled with care to support you through all your rhythms.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSlide(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          // Shy character — fits the "tell us your name" moment perfectly
          Image.asset(
            AppIllustrations.shy,
            width: 150,
            height: 150,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox(height: 150),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'What should we call you? 💕',
            textAlign: TextAlign.center,
            style: AppTypography.displayMedium.copyWith(
              color: isDark ? AppColors.darkText : AppColors.roseDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Luna will personalize all messages and comfort quotes for you.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          LunaCard(
            borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
            child: TextFormField(
              controller: _nameController,
              textAlign: TextAlign.center,
              style: AppTypography.titleLarge.copyWith(
                color: isDark ? AppColors.darkText : AppColors.charcoal,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your name...',
                hintStyle: AppTypography.titleLarge
                    .copyWith(color: AppColors.warmGray400),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleSlide(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tell us your rhythm 🌙',
            textAlign: TextAlign.center,
            style: AppTypography.displayMedium.copyWith(
              color: isDark ? AppColors.darkText : AppColors.roseDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'This enables calculations for predictions, ovulation dates, and self-care tips.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Cycle length slider
          LunaCard(
            borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cycle Duration', style: AppTypography.titleMedium),
                    Text('${_cycleLength.toInt()} Days', style: AppTypography.titleLarge.copyWith(color: AppColors.rosePrimary)),
                  ],
                ),
                Slider(
                  value: _cycleLength,
                  min: 21,
                  max: 45,
                  activeColor: AppColors.rosePrimary,
                  inactiveColor: AppColors.roseSoft,
                  onChanged: (val) => setState(() => _cycleLength = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Period length slider
          LunaCard(
            borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Period Duration', style: AppTypography.titleMedium),
                    Text('${_periodDuration.toInt()} Days', style: AppTypography.titleLarge.copyWith(color: AppColors.rosePrimary)),
                  ],
                ),
                Slider(
                  value: _periodDuration,
                  min: 3,
                  max: 10,
                  activeColor: AppColors.rosePrimary,
                  inactiveColor: AppColors.roseSoft,
                  onChanged: (val) => setState(() => _periodDuration = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Last period start date
          LunaCard(
            onTap: () => _selectDate(context),
            borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last Period Start Date', style: AppTypography.titleMedium),
                    const SizedBox(height: 2),
                    Text('Tap to pick the date', style: AppTypography.bodySmall.copyWith(color: AppColors.warmGray600)),
                  ],
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(_lastPeriodDate),
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.rosePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifySlide(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(
            'Keep in touch? 💌',
            textAlign: TextAlign.center,
            style: AppTypography.displayMedium.copyWith(
              color: isDark ? AppColors.darkText : AppColors.roseDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Would you like Luna to send you soft quotes, morning comfort, or prompt reminders selected just for you?',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          LunaCard(
            borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
            child: SwitchListTile(
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
              activeColor: AppColors.rosePrimary,
              title: Text('Loving Reminders', style: AppTypography.titleLarge),
              subtitle: Text('Soft checks and daily period tips', style: AppTypography.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvelopeSlide(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'A Sealed Letter ✉️',
            textAlign: TextAlign.center,
            style: AppTypography.displayMedium.copyWith(
              color: isDark ? AppColors.darkText : AppColors.roseDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'He left a secret message sealed specifically for your entry into this space.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Handwritten Letter envelope card
          LunaCard(
            color: isDark ? AppColors.darkCard : AppColors.goldSoft,
            borderColor: isDark ? AppColors.darkBorder : AppColors.goldMid,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('✉️', style: TextStyle(fontSize: 40)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Hey Priya,',
                  style: AppTypography.handwrittenLg.copyWith(
                    color: isDark ? AppColors.goldMid : AppColors.roseDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'I built this app for you because I care about your comfort and happiness more than anything. I want this space to be a warm embrace whenever you need it, and a safe repository for your thoughts. You are loved, always. 💕',
                  textAlign: TextAlign.center,
                  style: AppTypography.handwritten.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '— Yours Forever',
                  style: AppTypography.handwrittenLg.copyWith(
                    color: isDark ? AppColors.goldMid : AppColors.rosePrimary,
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
