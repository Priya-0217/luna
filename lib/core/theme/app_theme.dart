import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/role/app_role.dart';
import 'package:her/core/role/role_provider.dart';
import 'package:her/features/cycle/utils/cycle_calculator.dart';
import 'package:her/features/cycle/domain/cycle_phase.dart';

class ThemeFactory {
  static ThemeData buildTheme(
    AppRole role,
    Brightness brightness, {
    CyclePhase? phase,
  }) {
    final isDark = brightness == Brightness.dark;

    // Core color selection based on role, with phase override
    Color primaryColor;
    if (phase != null) {
      primaryColor = CycleCalculator.getPhaseColor(phase);
    } else {
      primaryColor = role == AppRole.him
          ? AppColors.mauvePrimary
          : AppColors.rosePrimary;
    }

    final secondaryColor = AppColors.goldPrimary;
    final backgroundColor = isDark
        ? AppColors.darkBackground
        : (role == AppRole.him
              ? AppColors.mauveSoft
              : AppColors.roseLight);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: primaryColor,
              secondary: secondaryColor,
              surface: AppColors.darkCard,
              error: AppColors.error,
            )
          : ColorScheme.light(
              primary: primaryColor,
              secondary: secondaryColor,
              surface: AppColors.white,
              error: AppColors.error,
            ),
      textTheme:
          GoogleFonts.dmSansTextTheme(
            isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
          ).copyWith(
            displayLarge: GoogleFonts.cormorantGaramond(
              fontWeight: FontWeight.w300,
              color: isDark ? AppColors.darkText : AppColors.darkText,
            ),
            displayMedium: GoogleFonts.cormorantGaramond(
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.darkText : AppColors.darkText,
            ),
            headlineLarge: GoogleFonts.cormorantGaramond(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.darkText,
            ),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cormorantGaramond(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }
}

// Note: In a full app, we would have a provider that fetches the current phase
// from Firestore to drive this theme change. For now, we provide the hook.
final themeProvider = ProviderFamily<ThemeData, Brightness>((ref, brightness) {
  final role = ref.watch(currentRoleProvider);
  // We could watch a currentPhaseProvider here
  return ThemeFactory.buildTheme(role, brightness);
});
