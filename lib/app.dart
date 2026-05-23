import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/router/app_router.dart';

class LunaApp extends ConsumerWidget {
  const LunaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterHelperProvider);

    return MaterialApp.router(
      title: 'Luna',
      debugShowCheckedModeBanner: false,
      routerConfig: router,

      // === LIGHT THEME SPECIFICATION ===
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.roseLight,
        colorScheme: const ColorScheme.light(
          primary: AppColors.rosePrimary,
          secondary: AppColors.mauvePrimary,
          surface: AppColors.white,
          error: AppColors.error,
        ),
        textTheme: GoogleFonts.dmSansTextTheme(
          ThemeData.light().textTheme,
        ).copyWith(
          // override title display fonts to Cormorant
          displayLarge: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w300),
          displayMedium: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w400),
          displaySmall: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w400),
          headlineLarge: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w500),
          headlineMedium: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w400),
          headlineSmall: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w400),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.roseSoft,
          thickness: 1.0,
        ),
      ),

      // === DARK THEME SPECIFICATION ===
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.rosePrimary,
          secondary: AppColors.mauveMid,
          surface: AppColors.darkCard,
          error: AppColors.error,
        ),
        textTheme: GoogleFonts.dmSansTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w300, color: AppColors.darkText),
          displayMedium: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w400, color: AppColors.darkText),
          displaySmall: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w400, color: AppColors.darkText),
          headlineLarge: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w500, color: AppColors.darkText),
          headlineMedium: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w400, color: AppColors.darkText),
          headlineSmall: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w400, color: AppColors.darkText),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkBorder,
          thickness: 1.0,
        ),
      ),
      themeMode: ThemeMode.system, // adapt dynamically to device state
    );
  }
}
