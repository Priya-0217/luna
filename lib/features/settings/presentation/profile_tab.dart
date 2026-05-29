import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/illustrated_card.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/router/app_routes.dart';
import 'package:her/features/auth/providers/auth_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('👤 ProfileTab: Building...');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Read current user's display name from the auth state
    final user = ref.watch(authProvider).valueOrNull;
    final displayName = user?.displayName ?? 'There';
    final isHim = user?.role == 'him';

    if (isHim) {
      debugPrint('👤 ProfileTab: User is HIM. Linked: ${user?.isLinked}');
    }

    final primaryColor = isHim
        ? AppColors.slateBluePrimary
        : AppColors.rosePrimary;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isHim ? 'Your Space 💙' : 'Your Space 🌸',
              style: AppTypography.displayLarge.copyWith(
                color: isDark
                    ? AppColors.darkText
                    : (isHim ? AppColors.slateBlueDark : AppColors.roseDark),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Profile Info Header — shows the real name from Firebase
            IllustratedCard(
              title: "$displayName's Space",
              subtitle: 'Your Luna — always here for you.',
              illustration: AppIllustrations.cozy,
            ),
            const SizedBox(height: 24),

            if (user != null && !user.isLinked && user.myLoveCode != null) ...[
              LunaCard(
                borderColor: primaryColor.withOpacity(0.3),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.link, color: primaryColor),
                        const SizedBox(width: 12),
                        Text(
                          "Partner Connection",
                          style: AppTypography.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Share your code to link with your partner:",
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.myLoveCode!,
                            style: AppTypography.titleLarge.copyWith(
                              letterSpacing: 2,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: user.myLoveCode!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Code copied! ${isHim ? '💙' : '💕'}',
                                  ),
                                  backgroundColor: primaryColor,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.push('/code-entry'),
                      child: Text(
                        "Have a code from them? Enter it here",
                        style: AppTypography.labelSmall.copyWith(
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Options List
            LunaCard(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.settings_outlined, color: primaryColor),
                    title: Text(
                      'App Settings',
                      style: AppTypography.titleMedium,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.pushNamed(AppRoutes.settings),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.lock_outline, color: primaryColor),
                    title: Text(
                      'Biometrics & App Lock',
                      style: AppTypography.titleMedium,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.pushNamed(AppRoutes.appLock),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.error),
                    title: Text(
                      'Logout',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _confirmLogout(context, ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Confirm then call the real Firebase logout ─────────────────────────────
  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logging out 🌸', style: AppTypography.titleLarge),
        content: Text(
          'Are you sure you want to sign out? All your data stays safe in the cloud.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Sign Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
      // Router redirect will automatically send us to /login
      // because authProvider will emit null after sign-out.
    }
  }
}
