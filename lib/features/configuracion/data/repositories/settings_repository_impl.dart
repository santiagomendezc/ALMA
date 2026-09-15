import 'package:aplicacion/core/error/failures.dart';
import 'package:aplicacion/features/configuracion/data/datasources/settings_local_data_source.dart';
import 'package:aplicacion/features/configuracion/domain/entities/game_settings.dart';
import 'package:aplicacion/features/configuracion/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, GameSettings>> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(GameSettings settings) async {
    try {
      await localDataSource.cacheSettings(settings);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
