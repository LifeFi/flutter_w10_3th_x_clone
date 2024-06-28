import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/models/settings_model.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/repos/settings_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsViewModel extends Notifier<SettingsModel> {
  final SettingsRepository _repository;

  SettingsViewModel(this._repository);

  void setThemeMode(ThemeMode newThemeMode) {
    _repository.setThemeMode(newThemeMode);
    state = SettingsModel(
      themeMode: newThemeMode,
    );
  }

  @override
  SettingsModel build() {
    return SettingsModel(
      themeMode: _repository.getThemeMode(),
    );
  }
}

final settingsProvider = NotifierProvider<SettingsViewModel, SettingsModel>(
  // main.dart 에서 override
  () => throw UnimplementedError(),
);
