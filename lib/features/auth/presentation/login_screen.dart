import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/animated_gradient_bg.dart';
import 'package:her/core/widgets/floating_particles.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/router/app_routes.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/core/services/auth_service.dart';
import 'package:her/features/home/domain/cycle_phase.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      debugPrint(
        '🔑 LoginScreen: Attempting login for ${_emailController.text.trim()}',
      );
      ref
          .read(authProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text.trim())
          .then((_) {
            // Only run after successful login state update
            if (mounted && ref.read(authProvider).hasValue) {
              final user = ref.read(authProvider).value;
              debugPrint(
                '🔑 LoginScreen: User state after login: ${user?.uid}, role: ${user?.role}, isOnboarded: ${user?.isOnboarded}',
              );

              if (user != null && user.isOnboarded) {
                debugPrint('🔑 LoginScreen: Redirecting to home...');
                context.goNamed(AppRoutes.home);
              }
            }
          })
          .catchError((e) {
            debugPrint('🔑 LoginScreen: Login error caught: $e');
          });
    }
  }

  void _friendlyError(String msg, BuildContext context) {
    String message = _getFriendlyErrorMessage(msg);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.bodySmall.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  String _getFriendlyErrorMessage(String raw) {
    if (raw.contains('user-not-found') ||
        raw.contains('wrong-password') ||
        raw.contains('invalid-credential')) {
      return "Hmm, those details don't match 🌸 — please try again.";
    }
    if (raw.contains('too-many-requests')) {
      return 'Too many attempts 💕 — take a breath and try later.';
    }
    if (raw.contains('network')) {
      return "No connection right now 🌙 — check your internet and try again.";
    }
    return "Something didn't connect — your data is safe, we'll try again 🌸";
  }

  void _showForgotPassword() {
    final emailCtrl = TextEditingController(text: _emailController.text.trim());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reset Password 🌸', style: AppTypography.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "We'll send a reset link to your email.",
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Your email address',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref
                    .read(authServiceProvider)
                    .sendPasswordResetEmail(emailCtrl.text.trim());
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Reset link sent 🌸 — check your inbox!',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: AppColors.rosePrimary,
                    ),
                  );
                }
              } catch (_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Couldn't send reset email — check the address.",
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Send Reset Link',
              style: TextStyle(color: AppColors.rosePrimary),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTypography.bodySmall.copyWith(
        color: isDark ? AppColors.warmGray400 : AppColors.roseDark,
      ),
      hintText: hint,
      hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.warmGray400),
      prefixIcon: Icon(
        icon,
        color: isDark ? AppColors.roseSoft : AppColors.rosePrimary,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark
          ? AppColors.darkSurface
          : AppColors.roseLight.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.rosePrimary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Show error snackbar when login fails
    ref.listen<AsyncValue<dynamic>>(authProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        _friendlyError(next.error.toString(), context);
      }
    });

    final background = AnimatedGradientBackground(
      phase: CyclePhase.follicular,
      child: FloatingParticles(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Heading ──────────────────────────────────────────
                    Text(
                      'Welcome back, Love 🌸',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayMedium.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.roseDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Take a deep breath and settle in.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.warmGray400
                            : AppColors.warmGray600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // ── Login Card ────────────────────────────────────────
                    LunaCard(
                      borderColor: isDark
                          ? AppColors.darkBorder
                          : AppColors.roseSoft,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.charcoal,
                            ),
                            decoration: _fieldDecoration(
                              label: 'Your Email',
                              hint: 'hello@example.com',
                              icon: Icons.mail_outline,
                              isDark: isDark,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email 🌸';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return "Let's enter a valid email 💕";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.charcoal,
                            ),
                            decoration: _fieldDecoration(
                              label: 'Your Password',
                              hint: '••••••••',
                              icon: Icons.lock_outlined,
                              isDark: isDark,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: isDark
                                      ? AppColors.warmGray400
                                      : AppColors.rosePrimary,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your password 💕';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters 🌱';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Sign-In Button
                          LunaButton(
                            text: 'Enter Luna',
                            isLoading: authState.isLoading,
                            onPressed: _submit,
                          ),

                          // Forgot password link
                          const SizedBox(height: AppSpacing.md),
                          TextButton(
                            onPressed: _showForgotPassword,
                            child: Text(
                              'Forgot your password?',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.warmGray400
                                    : AppColors.warmGray600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // ── Sign-up link ──────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.warmGray400
                                : AppColors.warmGray600,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.pushNamed(AppRoutes.signup),
                          child: Text(
                            'Create Your Space',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.rosePrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      body: background,
    );
  }
}
