import 'package:aplicacion/features/configuracion/domain/entities/game_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<GameSettings> getSettings();
  Future<void> cacheSettings(GameSettings settings);
}

const CACHED_SETTINGS_SPEED = 'CACHED_SETTINGS_SPEED';
const CACHED_SETTINGS_GRAPHICS = 'CACHED_SETTINGS_GRAPHICS';
const CACHED_SETTINGS_CLAVE = 'CACHED_SETTINGS_CLAVE';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<GameSettings> getSettings() {
    final speed = sharedPreferences.getDouble(CACHED_SETTINGS_SPEED) ?? 1.0;
    final graphics = sharedPreferences.getBool(CACHED_SETTINGS_GRAPHICS) ?? false;
    final claveIndex = sharedPreferences.getInt(CACHED_SETTINGS_CLAVE) ?? 0;
    final clave = ClaveMusical.values[claveIndex];

    return Future.value(GameSettings(speed: speed, alternativeGraphics: graphics, clave: clave));
  }

  @override
  Future<void> cacheSettings(GameSettings settings) {
    sharedPreferences.setDouble(CACHED_SETTINGS_SPEED, settings.speed);
    sharedPreferences.setBool(CACHED_SETTINGS_GRAPHICS, settings.alternativeGraphics);
    return Future.value();
  }
}
