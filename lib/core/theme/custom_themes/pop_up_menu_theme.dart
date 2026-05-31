// theme/custom_themes/popup_menu_theme.dart
import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomPopupMenuTheme {
  static PopupMenuThemeData light = PopupMenuThemeData(
    color: AppColors.surfaceLight,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontSize: 14, color: AppColors.onSurfaceLight),
    iconColor: AppColors.onSurfaceLight,
  );

  static PopupMenuThemeData dark = PopupMenuThemeData(
    color: AppColors.surfaceDark,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontSize: 14, color: AppColors.onSurfaceDark),
    iconColor: AppColors.onSurfaceDark,
  );
}