import 'package:aplicacion/features/configuracion/domain/entities/game_settings.dart';
import 'package:aplicacion/features/configuracion/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository repository;

  SettingsProvider({required this.repository});

  GameSettings _settings = GameSettings.defaultSettings();
  GameSettings get settings => _settings;

  Future<void> loadSettings() async {
    final result = await repository.getSettings();
    result.fold(
      (failure) => null, // Use default or handle error
      (settings) {
        _settings = settings;
        notifyListeners();
      },
    );
  }

  Future<void> updateSpeed(double newSpeed) async {
    _settings = _settings.copyWith(speed: newSpeed);
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  Future<void> toggleGraphics() async {
    _settings = _settings.copyWith(alternativeGraphics: !_settings.alternativeGraphics);
    notifyListeners();
    await repository.saveSettings(_settings);
  }

   Future<void> updateClave(ClaveMusical clave) async {
    _settings = _settings.copyWith(clave: clave);
    notifyListeners();
    await repository.saveSettings(_settings);
  }
}
