import 'package:flutter/material.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Read current user's display name from the auth state
    final user = ref.watch(authProvider).valueOrNull;
    final displayName = user?.displayName ?? 'There';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your Space 🌸',
              style: AppTypography.displayLarge.copyWith(
                color: isDark ? AppColors.darkText : AppColors.roseDark,
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

            // Options List
            LunaCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.rosePrimary,
                    ),
                    title: Text('App Settings', style: AppTypography.titleMedium),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.pushNamed(AppRoutes.settings),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.lock_outline,
                      color: AppColors.rosePrimary,
                    ),
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
                      style: AppTypography.titleMedium
                          .copyWith(color: AppColors.error),
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
            child: Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
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
