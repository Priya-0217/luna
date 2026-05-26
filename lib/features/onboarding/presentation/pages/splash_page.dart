import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/constants/app_illustrations.dart';

class SplashPage extends StatelessWidget {
  final VoidCallback onBegin;
  final VoidCallback onConnect;
  final bool isHim;
  final String? subtitle;

  const SplashPage({
    super.key,
    required this.onBegin,
    required this.onConnect,
    this.isHim = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        Text(
          "Luna",
          style: AppTypography.h1.copyWith(
            fontFamily: 'Cormorant Garamond',
            fontSize: 64,
            color: Colors.white,
            letterSpacing: -2,
          ),
        ),
        Text(
          subtitle ??
              (isHim ? "Made with her in mind." : "A space made just for you."),
          style: AppTypography.bodyMedium.copyWith(
            fontStyle: FontStyle.italic,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const Spacer(flex: 3),
        Image.asset(
          isHim ? AppIllustrations.inLove : AppIllustrations.hello,
          height: 200,
        ),
        const SizedBox(height: AppSpacing.xxl),
        ElevatedButton(
          onPressed: onBegin,
          style: ElevatedButton.styleFrom(
            backgroundColor: isHim
                ? AppColors.slateBlueMid
                : AppColors.rosePrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
            shape: const StadiumBorder(),
            elevation: 0,
          ),
          child: Text(
            isHim ? "Begin 💙" : "Begin ✦",
            style: AppTypography.h3.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextButton(
          onPressed: onConnect,
          child: Text(
            "Already have a code? Connect →",
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
