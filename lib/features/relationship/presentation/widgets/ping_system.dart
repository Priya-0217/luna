import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/relationship/data/relationship_repository.dart';

class PingSystem extends ConsumerStatefulWidget {
  const PingSystem({super.key});

  @override
  ConsumerState<PingSystem> createState() => _PingSystemState();
}

class _PingSystemState extends ConsumerState<PingSystem> {
  bool _isPinging = false;

  Future<void> _sendPing() async {
    final auth = ref.read(authProvider).value;
    if (auth?.coupleId == null) return;

    setState(() => _isPinging = true);
    try {
      // In a real app, this would trigger an FCM push notification via a Cloud Function
      // For now, we update a "lastPing" field in the relationship document which the other user watches
      await ref.read(relationshipRepositoryProvider).updateLastPing(
        auth!.coupleId!,
        auth.uid,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sent a 'Thinking of You' ping!"),
            backgroundColor: AppColors.rosePrimary,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPinging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.roseSoft.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.roseSoft.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: AppColors.rosePrimary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Thinking of Her?", style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                Text("Send a quick love ping.", style: AppTypography.bodySmall),
              ],
            ),
          ),
          IconButton(
            onPressed: _isPinging ? null : _sendPing,
            icon: _isPinging 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.send_rounded, color: AppColors.rosePrimary),
          ),
        ],
      ),
    );
  }
}
