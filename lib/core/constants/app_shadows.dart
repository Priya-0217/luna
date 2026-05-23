import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  // === Standard Card Shadow (Rose-tinted at 8% opacity) ===
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x14FF6B8A), // #FF6B8A at 8% opacity
      blurRadius: 20,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  // === Elevated Shadow (Floating components, rose at 12% opacity) ===
  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x1EFF6B8A), // #FF6B8A at 12% opacity
      blurRadius: 32,
      offset: Offset(0, 12),
      spreadRadius: -4,
    ),
  ];

  // === Subtle Shadow (Bottom nav, smaller items, rose at 4% opacity) ===
  static const List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Color(0x0AFF6B8A), // #FF6B8A at 4% opacity
      blurRadius: 10,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  // === Gold Shadow (Special From Him cards, gold at 15% opacity) ===
  static const List<BoxShadow> goldShadow = [
    BoxShadow(
      color: Color(0x26FFB830), // #FFB830 at 15% opacity
      blurRadius: 20,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];
}
