// theme/custom_themes/outlined_button_theme.dart
import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomOutlinedButtonTheme {
  static OutlinedButtonThemeData light = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      side: const BorderSide(color: AppColors.primaryLight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
  );

  static OutlinedButtonThemeData dark = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryDark,
      side: const BorderSide(color: AppColors.primaryDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
  );
}