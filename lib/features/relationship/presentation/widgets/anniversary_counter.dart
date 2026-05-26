import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/relationship/data/relationship_repository.dart';

class AnniversaryCounter extends ConsumerWidget {
  const AnniversaryCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider).value;
    final coupleId = auth?.coupleId;

    if (coupleId == null) return const SizedBox.shrink();

    return StreamBuilder<Map<String, dynamic>?>(
      stream: ref.watch(relationshipRepositoryProvider).watchRelationship(coupleId),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null || data['createdAt'] == null) {
          return const SizedBox.shrink();
        }

        final createdAt = (data['createdAt'] as Timestamp).toDate();
        final daysTogether = DateTime.now().difference(createdAt).inDays + 1;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Text(
                "$daysTogether",
                style: AppTypography.h1.copyWith(
                  fontSize: 72,
                  color: AppColors.rosePrimary,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "DAYS TOGETHER",
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: AppColors.warmGray500,
                ),
              ),
              const SizedBox(height: 4),
              const Icon(Icons.favorite, color: AppColors.roseSoft, size: 16),
            ],
          ),
        );
      },
    );
  }
}
