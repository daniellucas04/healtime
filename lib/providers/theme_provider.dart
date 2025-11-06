import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _init();
  }
  late bool isSystemThemeActive;
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  late ThemeMode _themeMode =
      brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

  static const String _themeKey = "themeMode";

  Future<bool> _checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_themeKey)) {
      int savedTheme = prefs.getInt(_themeKey) ?? 0;
      _themeMode = ThemeMode.values[savedTheme];
    } else {
      _themeMode = ThemeMode.system;
    }

    isSystemThemeActive = _themeMode == ThemeMode.system;
    notifyListeners();
    return true;
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.system
        ? brightness == Brightness.dark
            ? ThemeMode.light
            : ThemeMode.dark
        : _themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;

    await _saveTheme();
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Armazenar o índice do ThemeMode (0 - system, 1 - light, 2 - dark)
    prefs.setInt(_themeKey, _themeMode.index);
  }

  void setSystemThemeMode() async {
    _themeMode = ThemeMode.system;
    isSystemThemeActive = !isSystemThemeActive;

    await _saveTheme();
    notifyListeners();
  }

  Future<bool> _init() async {
    return await _checkTheme();
  }
}
