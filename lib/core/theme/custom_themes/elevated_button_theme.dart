// theme/custom_themes/elevated_button_theme.dart
import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomElevatedButtonTheme {
  static ElevatedButtonThemeData light = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.onPrimaryLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
  );

  static ElevatedButtonThemeData dark = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.onPrimaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
  );
}