import 'package:flutter/material.dart';

import '../app_colors.dart';

class CustomListTileTheme {

  static const light = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 10,
    ),
    horizontalTitleGap: 12,
    minLeadingWidth: 24,
    iconColor: AppColors.onSurfaceLight,
    textColor: AppColors.onSurfaceLight,
    shape: RoundedRectangleBorder(),
  );

  static const dark = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 10,
    ),
    horizontalTitleGap: 12,
    minLeadingWidth: 24,
    iconColor: AppColors.onSurfaceDark,
    textColor: AppColors.onSurfaceDark,
    shape: RoundedRectangleBorder(),
  );
}