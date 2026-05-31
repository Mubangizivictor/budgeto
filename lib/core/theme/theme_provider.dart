import 'package:budgeto/core/theme/v_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'is_dark_mode';
  bool _isDark = false;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDark => _isDark;
  ThemeData get themeData => _isDark ? VAppTheme.dark : VAppTheme.light;

  // Load saved preference on initialization
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  // Toggle and save the preference
  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDark);
  }
}
