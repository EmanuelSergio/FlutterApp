import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

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

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Network
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://hp-api.onrender.com/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
      ),
    ),
  );

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
