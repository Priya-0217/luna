import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_shadows.dart';

enum LunaShadowStyle {
  card,
  elevated,
  subtle,
  gold,
  none,
}

class LunaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final LunaShadowStyle shadowStyle;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const LunaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.color,
    this.borderColor,
    this.shadowStyle = LunaShadowStyle.card,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = color ?? (isDark ? AppColors.darkCard : AppColors.white);

    List<BoxShadow>? shadows;
    switch (shadowStyle) {
      case LunaShadowStyle.card:
        shadows = isDark ? null : AppShadows.cardShadow;
        break;
      case LunaShadowStyle.elevated:
        shadows = isDark ? null : AppShadows.elevatedShadow;
        break;
      case LunaShadowStyle.subtle:
        shadows = isDark ? null : AppShadows.subtleShadow;
        break;
      case LunaShadowStyle.gold:
        shadows = isDark ? null : AppShadows.goldShadow;
        break;
      case LunaShadowStyle.none:
        shadows = null;
        break;
    }

    final cardDecoration = BoxDecoration(
      color: cardBg,
      borderRadius: AppRadius.cardRadius,
      border: borderColor != null
          ? Border.all(color: borderColor!, width: 1.0)
          : (isDark
              ? Border.all(color: AppColors.darkBorder, width: 1.0)
              : null),
      boxShadow: shadows,
    );

    if (onTap != null) {
      return Container(
        width: width,
        height: height,
        margin: margin,
        decoration: cardDecoration,
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.cardRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.cardRadius,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16.0),
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: cardDecoration,
      child: child,
    );
  }
}

