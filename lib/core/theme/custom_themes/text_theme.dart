// theme/custom_themes/text_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';

class CustomTextTheme {
  static TextTheme light = TextTheme(
    bodyLarge: GoogleFonts.dmSans(
      fontSize: 16,
      color: AppColors.onSurfaceLight,
    ),
    bodyMedium: GoogleFonts.dmSans(
      fontSize: 14,
      color: AppColors.onSurfaceLight,
    ),
    titleLarge: GoogleFonts.dmSerifDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurfaceLight,
    ),
    titleMedium: GoogleFonts.dmSerifDisplay(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.onSurfaceLight,
    ),
    labelLarge: GoogleFonts.dmMono(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.onPrimaryLight,
    ),
  );

  static TextTheme dark = TextTheme(
    bodyLarge: GoogleFonts.dmSans(
      fontSize: 16,
      color: AppColors.onSurfaceDark,
    ),
    bodyMedium: GoogleFonts.dmSans(
      fontSize: 14,
      color: AppColors.onSurfaceDark,
    ),
    titleLarge: GoogleFonts.dmSerifDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurfaceDark,
    ),
    titleMedium: GoogleFonts.dmSerifDisplay(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.onSurfaceDark,
    ),
    labelLarge: GoogleFonts.dmMono(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryDark,
    ),
  );
}