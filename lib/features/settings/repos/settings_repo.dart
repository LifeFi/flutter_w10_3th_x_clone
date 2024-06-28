import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const String _themeModeKey = "themeMode";

  final SharedPreferences _preferences;

  SettingsRepository(this._preferences);

  Future<void> setThemeMode(ThemeMode newThemeMode) async {
    //enum 을 index로 다루는 방법
    await _preferences.setInt(_themeModeKey, newThemeMode.index);
  }

  ThemeMode getThemeMode() {
    // Future, Async 를 사용하는 것이 맞을 것 같은데,
    // SettingsViewModel 에서 future 사용하지 않으러고, return 문에 한줄로 작성했음.

    //enum 을 index로 다루는 방법
    return ThemeMode
        .values[_preferences.getInt(_themeModeKey) ?? ThemeMode.system.index];
  }
}
