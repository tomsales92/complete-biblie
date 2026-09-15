import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'themeMode';

class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.dark;

  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeModeKey);
    _mode = saved == 'light' ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  Future<void> setDark(bool dark) async {
    _mode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, dark ? 'dark' : 'light');
  }
}
