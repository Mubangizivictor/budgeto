// theme/custom_themes/floating_button_theme.dart
import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomFloatingButtonTheme {
  static FloatingActionButtonThemeData light = const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryLight,
    foregroundColor: AppColors.onPrimaryLight,
    shape: CircleBorder(),
  );

  static FloatingActionButtonThemeData dark = const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryDark,
    foregroundColor: AppColors.onPrimaryDark,
    shape: CircleBorder(),
  );
}