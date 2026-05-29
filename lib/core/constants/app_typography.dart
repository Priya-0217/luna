import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // === EMOTIONAL DISPLAY (Cormorant Garamond) ===
  static TextStyle get displayLarge => GoogleFonts.cormorantGaramond(
    fontSize: 40,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get displayMedium => GoogleFonts.cormorantGaramond(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static TextStyle get displaySmall => GoogleFonts.cormorantGaramond(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static TextStyle get headlineLarge => GoogleFonts.cormorantGaramond(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static TextStyle get headlineMed => GoogleFonts.cormorantGaramond(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static TextStyle get headlineMedItalic => GoogleFonts.cormorantGaramond(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.3,
  );

  // === SYSTEM BODY & LABELS (DM Sans) ===
  static TextStyle get titleLarge => GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle get titleMedium => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle get labelMedium => GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.3,
  );

  // === HANDWRITTEN (Caveat) ===
  static TextStyle get handwritten => GoogleFonts.caveat(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get handwrittenSm => GoogleFonts.caveat(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle get handwrittenLg => GoogleFonts.caveat(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // === COMPATIBILITY/LEGACY TOKENS ===
  static TextStyle get h1 => displayLarge;
  static TextStyle get h2 => displayMedium;
  static TextStyle get h3 => headlineLarge;
  static TextStyle get h4 => headlineMed;
  static TextStyle get labelSmall => bodySmall;
  static TextStyle get labelLarge => titleLarge;
}
