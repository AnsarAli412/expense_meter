import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Soft Indigo)
  static const Color primary = Color(0xFF6C5CE7);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFA29BFE);
  static const Color onPrimaryContainer = Color(0xFF2D3436);

  // Secondary Palette (Robins Egg Blue - Savings)
  static const Color secondary = Color(0xFF00CEC9);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF81ECEC);
  static const Color onSecondaryContainer = Color(0xFF006266);

  // Tertiary Palette (Pico Pink - Wants)
  static const Color tertiary = Color(0xFFFD79A8);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFD3E0);
  static const Color onTertiaryContainer = Color(0xFFB33771);

  // Error/Needs (Green Darner Tail - Needs / Red - Error)
  static const Color error = Color(0xFFFF7675); // Soft Red
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD9);
  static const Color onErrorContainer = Color(0xFF410002);

  static const Color needsColor = Color(0xFF74B9FF); // Soft Blue

  // Surface
  static const Color surface = Color(0xFFF4F7F6); // Very Light Grey/Blue
  static const Color onSurface = Color(0xFF2D3436); // Dark Slate

  // Custom
  static const Color income = Color(0xFF00B894); // Mint Green
  static const Color expense = Color(
    0xFFFF7675,
  ); // Pinkish Red (Same as error/expense)

  // UI Specific
  static const Color inputFill = Color(0xFFFFFFFF);
  static const Color cardSurface = Color(0xFFFFFFFF);
}
