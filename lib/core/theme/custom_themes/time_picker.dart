// theme/custom_themes/time_picker_theme.dart
import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomTimePickerTheme {
  static TimePickerThemeData light = TimePickerThemeData(
    backgroundColor: AppColors.surfaceLight,
    hourMinuteTextColor: AppColors.onSurfaceLight,
    dialHandColor: AppColors.primaryLight,
    dialBackgroundColor: AppColors.primaryContainerLight,
    hourMinuteColor: AppColors.primaryLight,
    dayPeriodColor: AppColors.primaryLight,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  );

  static TimePickerThemeData dark = TimePickerThemeData(
    backgroundColor: AppColors.surfaceDark,
    hourMinuteTextColor: AppColors.onSurfaceDark,
    dialHandColor: AppColors.primaryDark,
    dialBackgroundColor: AppColors.primaryContainerDark,
    hourMinuteColor: AppColors.primaryDark,
    dayPeriodColor: AppColors.primaryDark,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  );
}