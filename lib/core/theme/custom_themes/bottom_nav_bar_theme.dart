// utils/theme/custom_themes/bottom_nav_bar_theme.dart
import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomBottomNavBarTheme {
  static BottomNavigationBarThemeData light = BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent,
    selectedItemColor: AppColors.primaryLight,
    unselectedItemColor: Colors.grey.shade600,
    selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  );

  static BottomNavigationBarThemeData dark = BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent,
    selectedItemColor: AppColors.primaryDark,
    unselectedItemColor: Colors.grey.shade500,
    selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  );
}