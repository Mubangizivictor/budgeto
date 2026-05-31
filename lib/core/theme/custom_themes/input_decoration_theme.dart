// theme/custom_themes/input_decoration_theme.dart
import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomInputDecorationTheme {
  static InputDecorationTheme light = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceLight,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.borderLight, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.overdue, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.overdue, width: 1.5),
    ),
    hintStyle: TextStyle(
      color: AppColors.subtitleLight,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.3,
    ),
    errorStyle: const TextStyle(
      fontSize: 12,
      color: AppColors.overdue,
      fontWeight: FontWeight.w400,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    alignLabelWithHint: true,
    prefixIconConstraints: const BoxConstraints(minWidth: 40),
    suffixIconConstraints: const BoxConstraints(minWidth: 40),
  );

  static InputDecorationTheme dark = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.borderDark, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.overdue, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.overdue, width: 1.5),
    ),
    hintStyle: TextStyle(
      color: AppColors.subtitleDark,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.3,
    ),
    errorStyle: const TextStyle(
      fontSize: 12,
      color: AppColors.overdue,
      fontWeight: FontWeight.w400,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    alignLabelWithHint: true,
    prefixIconConstraints: const BoxConstraints(minWidth: 40),
    suffixIconConstraints: const BoxConstraints(minWidth: 40),
  );
}