import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'custom_themes/app_bar_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/floating_button_theme.dart';
import 'custom_themes/input_decoration_theme.dart';
import 'custom_themes/list_tile_theme.dart';
import 'custom_themes/outlined_button_theme.dart';
import 'custom_themes/text_theme.dart';

class VAppTheme {

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      primaryContainer: AppColors.primaryContainerLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,
      onPrimary: AppColors.onPrimaryLight,
    ),

    appBarTheme: CustomAppBarTheme.light,
    textTheme: CustomTextTheme.light,
    elevatedButtonTheme: CustomElevatedButtonTheme.light,
    outlinedButtonTheme: CustomOutlinedButtonTheme.light,
    floatingActionButtonTheme: CustomFloatingButtonTheme.light,
    listTileTheme: CustomListTileTheme.light,
    inputDecorationTheme: CustomInputDecorationTheme.light,

    useMaterial3: true,
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      primaryContainer: AppColors.primaryContainerDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      onPrimary: AppColors.onPrimaryDark,
    ),

    appBarTheme: CustomAppBarTheme.dark,
    textTheme: CustomTextTheme.dark,
    elevatedButtonTheme: CustomElevatedButtonTheme.dark,
    outlinedButtonTheme: CustomOutlinedButtonTheme.dark,
    floatingActionButtonTheme: CustomFloatingButtonTheme.dark,
    listTileTheme: CustomListTileTheme.dark,
    inputDecorationTheme: CustomInputDecorationTheme.dark,

    useMaterial3: true,
  );
}