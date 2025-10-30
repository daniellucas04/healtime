import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool isSystemThemeActive = false;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setSystemThemeMode() {
    _themeMode = ThemeMode.system;
    isSystemThemeActive = !isSystemThemeActive;
    notifyListeners();
  }
}
