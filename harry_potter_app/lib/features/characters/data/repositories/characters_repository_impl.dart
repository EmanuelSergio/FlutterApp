import 'package:dio/dio.dart';

import '../../domain/entities/character.dart';
import '../../domain/repositories/characters_repository.dart';
import '../datasources/characters_remote_datasource.dart';
import '../mappers/character_mapper.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersRemoteDataSource remote;
  CharactersRepositoryImpl(this.remote);

  @override
  Future<List<Character>> getAllCharacters() async {
    final result = await remote.getAllCharacters();
    return result.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Character> getCharacterById(String id) async {
    final result = await remote.getCharacterById(id);
    return result.toEntity();
  }

  @override
  Future<List<Character>> getCharactersByHouse(String house) async {
    final result = await remote.getCharactersByHouse(house);
    return result.map((m) => m.toEntity()).toList();
  }
}
