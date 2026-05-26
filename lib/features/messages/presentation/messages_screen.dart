import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/role/role_provider.dart';

class MessagesScreen extends ConsumerWidget {
  final String fromRole;
  const MessagesScreen({super.key, required this.fromRole});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.softIvory,
      appBar: AppBar(
        title: Text("Connected Chat", style: AppTypography.h3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.roseSoft),
            const SizedBox(height: 24),
            Text("Coming Soon", style: AppTypography.h4),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                "Real-time intimate messaging between you and your partner is being prepared.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.warmGray400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
