import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';

/// A user avatar widget that shows a photo or falls back to initials.
class LunaAvatar extends StatelessWidget {
  const LunaAvatar({
    super.key,
    this.displayName,
    this.photoUrl,
    this.radius = 28,
    this.backgroundColor,
  });

  final String? displayName;
  final String? photoUrl;
  final double radius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkCard : AppColors.roseSoft);

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoUrl!),
        backgroundColor: bgColor,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Text(
        _initials,
        style: AppTypography.titleMedium.copyWith(
          color: AppColors.rosePrimary,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.65,
        ),
      ),
    );
  }

  String get _initials {
    if (displayName == null || displayName!.isEmpty) return '🌸';
    final parts = displayName!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }
}
