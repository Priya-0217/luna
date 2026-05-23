import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_shadows.dart';
import 'package:her/core/constants/app_typography.dart';

enum LunaButtonVariant {
  primary,
  secondary,
  ghost,
}

class LunaButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final LunaButtonVariant variant;
  final Widget? icon;
  final double? width;
  final double height;
  final bool isLoading;
  final Color? backgroundColor;

  const LunaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = LunaButtonVariant.primary,
    this.icon,
    this.width,
    this.height = 48.0,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  State<LunaButton> createState() => _LunaButtonState();
}

class _LunaButtonState extends State<LunaButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color textColor;
    Gradient? gradient;
    Color? backgroundColor;
    List<BoxShadow>? shadows;
    Border? border;

    switch (widget.variant) {
      case LunaButtonVariant.primary:
        textColor = AppColors.white;
        gradient = (widget.onPressed != null && widget.backgroundColor == null)
            ? const LinearGradient(
                colors: [AppColors.rosePrimary, AppColors.roseDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null;
        backgroundColor = widget.backgroundColor ??
            (widget.onPressed == null
                ? (isDark ? AppColors.darkBorder : AppColors.roseSoft)
                : null);
        shadows = (widget.onPressed != null && !isDark)
            ? AppShadows.subtleShadow
            : null;
        break;

      case LunaButtonVariant.secondary:
        textColor = isDark ? AppColors.darkText : AppColors.roseDark;
        backgroundColor = isDark ? AppColors.darkCard : AppColors.roseLight;
        border = Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.roseSoft,
          width: 1.5,
        );
        break;

      case LunaButtonVariant.ghost:
        textColor = isDark ? AppColors.roseSoft : AppColors.rosePrimary;
        backgroundColor = Colors.transparent;
        break;
    }

    final content = Center(
      child: widget.isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  widget.icon!,
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  widget.text,
                  style: AppTypography.labelMedium.copyWith(
                    color: widget.onPressed == null
                        ? (isDark ? AppColors.warmGray600 : AppColors.warmGray400)
                        : textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );

    final scale = _isPressed ? 0.95 : 1.0;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale(scale),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: AppRadius.pillRadius,
          gradient: gradient,
          color: backgroundColor,
          border: border,
          boxShadow: shadows,
        ),
        child: content,
      ),
    );
  }
}
