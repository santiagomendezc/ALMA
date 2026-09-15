import 'package:aplicacion/features/configuracion/domain/entities/game_settings.dart';
import 'package:dartz/dartz.dart';
import 'package:aplicacion/core/error/failures.dart';

abstract class SettingsRepository {
  Future<Either<Failure, GameSettings>> getSettings();
  Future<Either<Failure, void>> saveSettings(GameSettings settings);
}
