import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';

class LunaLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LunaLoading({
    super.key,
    this.width = double.infinity,
    this.height = 100.0,
    this.borderRadius = AppRadius.card,
  });

  // Pre-configured shimmer cards
  static Widget cardList({int count = 3}) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (_, __) => const LunaLoading(height: 120),
    );
  }

  static Widget circular({double size = 48}) {
    return LunaLoading(
      width: size,
      height: size,
      borderRadius: size / 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark ? AppColors.darkCard : AppColors.roseSoft;
    final highlightColor = isDark ? AppColors.darkSurface : AppColors.roseLight;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
    );
  }
}
