import 'package:flutter/material.dart';

class ThemeConfig extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  themeModeChange(ThemeMode newThemeMode) {
    themeMode = newThemeMode;
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    notifyListeners();
    return themeMode;
  }
}

final themeConfig = ThemeConfig();
