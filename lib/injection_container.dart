import 'package:aplicacion/core/audio/audio_service.dart';
import 'package:aplicacion/features/configuracion/data/datasources/settings_local_data_source.dart';
import 'package:aplicacion/features/configuracion/data/repositories/settings_repository_impl.dart';
import 'package:aplicacion/features/configuracion/domain/repositories/settings_repository.dart';
import 'package:aplicacion/features/configuracion/presentation/providers/settings_provider.dart';
import 'package:aplicacion/features/game/presentation/providers/game_provider.dart';
import 'package:aplicacion/features/user_management/data/datasources/user_local_data_source.dart';
import 'package:aplicacion/features/user_management/data/repositories/user_repository_impl.dart';
import 'package:aplicacion/features/user_management/domain/repositories/user_repository.dart';
import 'package:aplicacion/features/user_management/presentation/providers/user_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // ─── External ─────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<AudioService>(() => AudioService());

  // ─── Data sources ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // ─── Repositories ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localDataSource: sl<UserLocalDataSource>()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl<SettingsLocalDataSource>()),
  );

  // ─── Providers ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<UserProvider>(
    () => UserProvider(repository: sl<UserRepository>()),
  );
  sl.registerLazySingleton<SettingsProvider>(
    () => SettingsProvider(repository: sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<GameProvider>(
    () => GameProvider(
      settingsProvider: sl<SettingsProvider>(),
      audioService: sl<AudioService>(),
    ),
  );
}
