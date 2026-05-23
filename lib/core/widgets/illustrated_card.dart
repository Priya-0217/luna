import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_card.dart';

class IllustratedCard extends StatelessWidget {
  final String title;
  final String illustration; // asset path from AppIllustrations
  final String? subtitle;
  final Color? backgroundColor;
  final Alignment illustrationAlignment;
  final double illustrationSize;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? badge;

  const IllustratedCard({
    super.key,
    required this.title,
    required this.illustration,
    this.subtitle,
    this.backgroundColor,
    this.illustrationAlignment = Alignment.bottomRight,
    this.illustrationSize = 110.0,
    this.onTap,
    this.trailing,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBg = isDark ? AppColors.darkCard : AppColors.roseLight;
    final cardBg = backgroundColor ?? defaultBg;

    // Helper to extract clean character name for placeholder text
    final parts = illustration.split('/');
    final filename = parts.isNotEmpty ? parts.last : 'illustration';
    final cleanName = filename.replaceAll('.png', '').replaceAll('char_', '');

    // Setup positions based on Alignment
    final double? top = illustrationAlignment == Alignment.topRight ? 4.0 : null;
    final double? bottom = illustrationAlignment == Alignment.bottomRight ? -12.0 : null;
    final double? right = (illustrationAlignment == Alignment.topRight || illustrationAlignment == Alignment.bottomRight) ? -4.0 : null;

    final double? left = (illustrationAlignment == Alignment.topLeft || illustrationAlignment == Alignment.bottomLeft) ? -4.0 : null;
    final double? topL = illustrationAlignment == Alignment.topLeft ? 4.0 : null;
    final double? bottomL = illustrationAlignment == Alignment.bottomLeft ? -12.0 : null;

    Widget buildIllustration(BuildContext context) {
      return Image.asset(
        illustration,
        width: illustrationSize,
        height: illustrationSize,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Visual placeholder: roseSoft rounded container with name centered in white DM Sans
          return Container(
            width: illustrationSize * 0.9,
            height: illustrationSize * 0.9,
            decoration: BoxDecoration(
              color: AppColors.roseSoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.roseMid,
                width: 1.0,
              ),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Text(
              cleanName.toUpperCase(),
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.roseDark,
                fontWeight: FontWeight.bold,
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
          );
        },
      );
    }

    final cardBody = ClipRRect(
      borderRadius: AppRadius.cardRadius,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Text Content Area
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 20.0,
              left: 20.0,
              right: 110.0, // leave space for illustration
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (badge != null) ...[
                        badge!,
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      Text(
                        title,
                        style: AppTypography.titleLarge.copyWith(
                          color: isDark ? AppColors.darkText : AppColors.roseDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle!,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  trailing!,
                ],
              ],
            ),
          ),

          // Illustration Layer
          Positioned(
            top: top ?? topL,
            bottom: bottom ?? bottomL,
            right: right,
            left: left,
            child: MouseRegion(
              child: buildIllustration(context),
            ),
          ),
        ],
      ),
    );

    final cardWidget = LunaCard(
      color: cardBg,
      padding: EdgeInsets.zero,
      shadowStyle: isDark ? LunaShadowStyle.none : LunaShadowStyle.card,
      borderColor: isDark ? AppColors.darkBorder : AppColors.roseMid.withOpacity(0.5),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: cardBody,
      ),
    );

    // Staggered entry animation
    return cardWidget
        .animate()
        .fadeIn(duration: 350.ms, curve: Curves.easeOutCubic)
        .scale(begin: const Offset(0.95, 0.95), duration: 350.ms, curve: Curves.easeOutBack);
  }
}
