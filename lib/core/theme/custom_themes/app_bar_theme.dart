// theme/custom_themes/appbar_theme.dart
import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomAppBarTheme {
  static AppBarTheme light = const AppBarTheme(
    backgroundColor: AppColors.backgroundLight,
    foregroundColor: AppColors.onSurfaceLight,
    elevation: 0,
    scrolledUnderElevation: 0.5,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurfaceLight,
      letterSpacing: -0.3,
    ),
    iconTheme: IconThemeData(color: AppColors.onSurfaceLight, size: 24),
    actionsIconTheme: IconThemeData(color: AppColors.onSurfaceLight, size: 24),
  );

  static AppBarTheme dark = const AppBarTheme(
    backgroundColor: AppColors.backgroundDark,
    foregroundColor: AppColors.onSurfaceDark,
    elevation: 0,
    scrolledUnderElevation: 0.5,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurfaceDark,
      letterSpacing: -0.3,
    ),
    iconTheme: IconThemeData(color: AppColors.onSurfaceDark, size: 24),
    actionsIconTheme: IconThemeData(color: AppColors.onSurfaceDark, size: 24),
  );
}