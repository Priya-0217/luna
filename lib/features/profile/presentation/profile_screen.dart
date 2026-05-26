import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/core/role/app_role.dart';
import 'package:her/core/role/role_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).value;
    final role = ref.watch(currentRoleProvider);
    final isHer = role == AppRole.her;

    return Scaffold(
      backgroundColor: AppColors.softIvory,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: isHer ? AppColors.rosePrimary : AppColors.slateBlue,
              ),
              title: Text(
                "Settings",
                style: AppTypography.h3.copyWith(color: Colors.white),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 24),
              _ProfileSection(
                title: "Personal Details",
                children: [
                  ListTile(
                    title: const Text("Display Name"),
                    subtitle: Text(authState?.displayName ?? "Guest"),
                    trailing: const Icon(Icons.edit, size: 20),
                  ),
                  ListTile(
                    title: const Text("Email"),
                    subtitle: Text(authState?.email ?? "No email"),
                  ),
                ],
              ),
              _ProfileSection(
                title: "App Experience",
                children: [
                  ListTile(
                    title: const Text("Current Role"),
                    subtitle: Text(
                      isHer ? "Rose (Partner A)" : "Him (Partner B)",
                    ),
                    leading: Icon(
                      isHer ? Icons.person_pin : Icons.person_outline,
                    ),
                  ),
                  SwitchListTile(
                    title: const Text("Push Notifications"),
                    value: true,
                    onChanged: (v) {},
                    activeColor: AppColors.rosePrimary,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.redAccent,
                    elevation: 0,
                    side: const BorderSide(color: Colors.redAccent, width: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => ref.read(authProvider.notifier).signOut(),
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 64),
              const Center(
                child: Text(
                  "Luna v1.0.0",
                  style: TextStyle(color: AppColors.warmGray400, fontSize: 12),
                ),
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _ProfileSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.warmGray500,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
