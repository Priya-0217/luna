import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === PRIMARY PALETTE (Warm Dusty Rose — from reference) ===
  static const Color roseLight       = Color(0xFFFFF0F3);   // page background
  static const Color roseSoft        = Color(0xFFFFD6DE);   // card tint, chip bg, placeholder
  static const Color roseMid         = Color(0xFFFFB3C1);   // borders, dividers, unselected
  static const Color rosePrimary     = Color(0xFFFF6B8A);   // primary actions, active highlights
  static const Color roseDeep        = Color(0xFFE84D6F);   // pressed/active states
  static const Color roseDark        = Color(0xFFB5294B);   // text on light backgrounds

  // === ACCENT PALETTE (Warm Gold — for "From Him" section) ===
  static const Color goldSoft        = Color(0xFFFFF8E7);   // From Him card background tint
  static const Color goldMid         = Color(0xFFFFD97D);   // From Him card borders
  static const Color goldPrimary     = Color(0xFFFFB830);   // Hug button, primary gold

  // === SECONDARY PALETTE (Calming Mauve / Luteal Phase) ===
  static const Color mauveSoft       = Color(0xFFF5EEF8);   // Mauve background tint
  static const Color mauveMid        = Color(0xFFD7A8E0);   // Mauve borders
  static const Color mauvePrimary    = Color(0xFFB36CC8);   // Mauve details

  // === NEUTRALS (Warm White / Ivory) ===
  static const Color white           = Color(0xFFFFFFFF);
  static const Color ivory           = Color(0xFFFFFBF7);
  static const Color cream           = Color(0xFFFFF5EE);
  static const Color warmGray100     = Color(0xFFF7F0EC);
  static const Color warmGray200     = Color(0xFFEDE4DE);
  static const Color warmGray400     = Color(0xFFBFB0A8);
  static const Color warmGray600     = Color(0xFF8C7D76);
  static const Color warmGray800     = Color(0xFF4A3D38);
  static const Color charcoal        = Color(0xFF2D2420);

  // === SEMANTIC COLORS ===
  static const Color success         = Color(0xFF6DBF8A);   // soft green
  static const Color warning         = Color(0xFFFFB347);   // warm amber
  static const Color error           = Color(0xFFFF6B6B);   // soft red
  static const Color info            = Color(0xFF6BB8FF);   // soft blue

  // === CYCLE PHASE COLORS ===
  static const Color phaseMenstrual  = Color(0xFFFF6B8A);   // rose
  static const Color phaseFollicular = Color(0xFFFFB3C1);   // light rose
  static const Color phaseOvulation  = Color(0xFFFFD97D);   // gold
  static const Color phaseLuteal     = Color(0xFFD7A8E0);   // mauve

  // === DARK THEME OVERRIDES (Warm plum-black scheme) ===
  static const Color darkBackground  = Color(0xFF1A0F14);   // deep plum-black
  static const Color darkSurface     = Color(0xFF2D1B26);   // dark plum
  static const Color darkCard        = Color(0xFF3D2535);   // card surface
  static const Color darkBorder      = Color(0xFF5C3A4A);   // subtle border
  static const Color darkText        = Color(0xFFF5E6EC);   // soft warm white
  static const Color darkAccent      = Color(0xFFFF8FAA);   // rose on dark

  // === COMPATIBILITY/LEGACY TOKENS ===
  static const Color warmGray500     = warmGray600;
  static const Color warmGray300     = warmGray400;
  static const Color softIvory       = ivory;
  
  // === HIM PALETTE (Slate Blue) ===
  static const Color slateBlueLight  = Color(0xFFEEF1FF);   // page backgrounds
  static const Color slateBlueSoft   = Color(0xFFD0D9FF);   // card tints
  static const Color slateBlueMid    = Color(0xFFA8BBFF);   // borders, dividers
  static const Color slateBluePrimary = Color(0xFF6B8EFF);  // primary CTAs
  static const Color slateBlueDeep   = Color(0xFF4A6BE8);   // active/pressed
  static const Color slateBlueDark   = Color(0xFF2A45B0);   // text on light blue bg
  static const Color slateBlue       = slateBluePrimary;
}
