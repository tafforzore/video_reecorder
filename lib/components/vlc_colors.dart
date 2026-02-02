import 'package:flutter/material.dart';

class VlcColors {
  static const Color primaryBlue = Color(0xFF007ACC);
  static const Color secondaryBlue = Color(0xFF005A9E);
  static const Color accentBlue = Color(0xFF00A0E9);

  static List<Color> get gradientBackground => [
    Colors.blue.shade900.withOpacity(0.8),
    Colors.black,
    Colors.black,
  ];

  static List<Color> get glassCardGradient => [
    Colors.blue.shade800.withOpacity(0.3),
    Colors.blue.shade400.withOpacity(0.1),
  ];

  static Color get controlButtonColor => Colors.black.withOpacity(0.4);
  static Color get borderColor => Colors.blue.shade300.withOpacity(0.3);
  static Color get textColor => Colors.blue.shade300;
  static Color get mutedTextColor => Colors.blue.shade300.withOpacity(0.7);
}