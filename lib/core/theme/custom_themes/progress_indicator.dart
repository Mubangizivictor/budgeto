// theme/custom_themes/progress_indicator_theme.dart
import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomProgressIndicatorTheme {
  static ProgressIndicatorThemeData light = const ProgressIndicatorThemeData(
    color: AppColors.primaryLight,
    circularTrackColor: Color(0xFFE5E5E5),
    linearTrackColor: Color(0xFFE5E5E5),
  );

  static ProgressIndicatorThemeData dark = const ProgressIndicatorThemeData(
    color: AppColors.primaryDark,
    circularTrackColor: Color(0xFF2A2A2A),
    linearTrackColor: Color(0xFF2A2A2A),
  );
}