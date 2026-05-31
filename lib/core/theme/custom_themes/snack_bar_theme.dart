import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomSnackBarTheme {
  static SnackBarThemeData light = SnackBarThemeData(
    backgroundColor: const Color(0xFF1F1F1F),
    contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
    actionTextColor: AppColors.primaryLight,
    elevation: 4,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    width: 440,
  );

  static SnackBarThemeData dark = SnackBarThemeData(
    backgroundColor: const Color(0xFF2C2C2C),
    contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
    actionTextColor: AppColors.primaryDark,
    elevation: 4,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    width: 440,
  );
}