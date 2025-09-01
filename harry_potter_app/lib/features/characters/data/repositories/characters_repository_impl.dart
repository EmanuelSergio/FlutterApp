import '../../domain/entities/character.dart';
import '../../domain/repositories/characters_repository.dart';
import '../datasources/characters_remote_datasource.dart';
import '../mappers/character_mapper.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersRemoteDataSource remote;
  CharactersRepositoryImpl(this.remote);

  // Simple in-memory caches
  List<Character>? _allCache;
  final Map<String, List<Character>> _houseCache = {};
  final Map<String, Character> _byIdCache = {};

  @override
  Future<List<Character>> getAllCharacters() async {
    if (_allCache != null) return _allCache!;
    final result = await remote.getAllCharacters();
    _allCache = result.map((m) => m.toEntity()).toList();
    return _allCache!;
  }

  @override
  Future<Character> getCharacterById(String id) async {
    if (_byIdCache.containsKey(id)) return _byIdCache[id]!;
    final result = await remote.getCharacterById(id);
    final entity = result.toEntity();
    _byIdCache[id] = entity;
    return entity;
  }

  @override
  Future<List<Character>> getCharactersByHouse(String house) async {
    final key = house.toLowerCase();
    if (_houseCache.containsKey(key)) return _houseCache[key]!;
    final result = await remote.getCharactersByHouse(key);
    final list = result.map((m) => m.toEntity()).toList();
    _houseCache[key] = list;
    return list;
  }
}
