import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';

class LunaChip extends StatefulWidget {
  final String label;
  final IconData? icon;
  final String? thumbnail; // character thumbnail asset path
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;

  const LunaChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.thumbnail,
    this.selectedColor,
  });

  @override
  State<LunaChip> createState() => _LunaChipState();
}

class _LunaChipState extends State<LunaChip> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryCol = widget.selectedColor ?? AppColors.rosePrimary;

    Color bg;
    Color borderCol;
    Color textColor;

    if (widget.isSelected) {
      bg = primaryCol;
      borderCol = primaryCol;
      textColor = AppColors.white;
    } else {
      bg = isDark ? AppColors.darkCard : AppColors.white;
      borderCol = isDark ? AppColors.darkBorder : AppColors.roseSoft;
      textColor = isDark ? AppColors.darkText : AppColors.charcoal;
    }

    final scale = _isPressed ? 0.95 : 1.0;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale(scale),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.pillRadius,
          border: Border.all(color: borderCol, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Character thumbnail
            if (widget.thumbnail != null) ...[
              // We support visual fallback block for character thumbnail as well
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected ? AppColors.white.withOpacity(0.2) : AppColors.roseSoft,
                ),
                alignment: Alignment.center,
                child: ClipOval(
                  child: Image.asset(
                    widget.thumbnail!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Visual fallback block: show tiny initials
                      return Text(
                        widget.label.substring(0, 1).toUpperCase(),
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: widget.isSelected ? AppColors.white : AppColors.roseDark,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ] else if (widget.icon != null) ...[
              Icon(
                widget.icon,
                size: 16,
                color: widget.isSelected ? AppColors.white : primaryCol,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              widget.label,
              style: AppTypography.bodySmall.copyWith(
                color: textColor,
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
