import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/characters/data/datasources/characters_remote_datasource.dart';
import '../../features/characters/data/repositories/characters_repository_impl.dart';
import '../../features/characters/domain/repositories/characters_repository.dart';
import '../../features/characters/domain/usecases/get_all_characters.dart';
import '../../features/characters/domain/usecases/get_character_by_id.dart';
import '../../features/characters/domain/usecases/get_characters_by_house.dart';
import '../../features/spells/data/datasources/spells_remote_datasource.dart';
import '../../features/spells/data/repositories/spells_repository_impl.dart';
import '../../features/spells/domain/repositories/spells_repository.dart';
import '../../features/spells/domain/usecases/get_spells.dart';
import '../preferences/app_preferences.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Init Hive
  await Hive.initFlutter();
  await Hive.openBox('cache');
  await Hive.openBox('prefs');

  // Network
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://hp-api.onrender.com/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (e, handler) async {
        // simple retry once on network errors
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.connectionError) {
          try {
            final req = await dio.fetch(e.requestOptions);
            return handler.resolve(req);
          } catch (_) {}
        }
        return handler.next(e);
      },
    ),
  );

  sl.registerLazySingleton<Dio>(() => dio);

  // Preferences
  sl.registerLazySingleton<AppPreferences>(() => HiveAppPreferences());

  // Data sources
  sl.registerLazySingleton<CharactersRemoteDataSource>(
    () => CharactersRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SpellsRemoteDataSource>(
    () => SpellsRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<CharactersRepository>(
    () => CharactersRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SpellsRepository>(() => SpellsRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory(() => GetAllCharacters(sl()));
  sl.registerFactory(() => GetCharactersByHouse(sl()));
  sl.registerFactory(() => GetCharacterById(sl()));
  sl.registerFactory(() => GetSpells(sl()));
}
