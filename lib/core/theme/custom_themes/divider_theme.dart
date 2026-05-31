import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomDividerTheme {
  static const DividerThemeData light = DividerThemeData(
    color: AppColors.borderLight,
    thickness: 0.5,
    space: 1,
  );

  static const DividerThemeData dark = DividerThemeData(
    color: AppColors.borderDark,
    thickness: 0.5,
    space: 1,
  );
}