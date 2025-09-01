import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/network/endpoints.dart';
import '../models/character_model.dart';

abstract class CharactersRemoteDataSource {
  Future<List<CharacterModel>> getAllCharacters();
  Future<List<CharacterModel>> getCharactersByHouse(String house);
  Future<CharacterModel> getCharacterById(String id);
}

class CharactersRemoteDataSourceImpl implements CharactersRemoteDataSource {
  final Dio dio;
  CharactersRemoteDataSourceImpl(this.dio);

  Box get _box => Hive.box('cache');

  // TTL cache support (1 hour)
  static const Duration _cacheTtl = Duration(hours: 1);

  void _putCache(String key, dynamic data) {
    _box.put(key, {'ts': DateTime.now().millisecondsSinceEpoch, 'data': data});
  }

  T? _getFreshCache<T>(String key) {
    final cached = _box.get(key);
    if (cached is Map && cached['ts'] is int) {
      final ts = DateTime.fromMillisecondsSinceEpoch(cached['ts'] as int);
      if (DateTime.now().difference(ts) <= _cacheTtl) {
        return cached['data'] as T?;
      }
      return null; // stale
    }
    // Backward compatibility: previously we stored raw List/Map
    return cached as T?;
  }

  @override
  Future<List<CharacterModel>> getAllCharacters() async {
    const key = 'characters_all';
    try {
      final res = await dio.get(Endpoints.characters);
      final data = (res.data as List).cast<Map<String, dynamic>>();
      _putCache(key, res.data);
      return data.map(CharacterModel.fromJson).toList();
    } catch (_) {
      final cached = _getFreshCache<List>(key);
      if (cached is List) {
        final data = cached.cast<Map>().cast<Map<String, dynamic>>();
        return data.map(CharacterModel.fromJson).toList();
      }
      rethrow;
    }
  }

  @override
  Future<CharacterModel> getCharacterById(String id) async {
    final key = 'character_$id';
    try {
      final res = await dio.get('${Endpoints.characterById}/$id');
      final body = res.data;
      _putCache(key, body);
      if (body is List && body.isNotEmpty) {
        return CharacterModel.fromJson(
          (body.first as Map).cast<String, dynamic>(),
        );
      } else if (body is Map) {
        return CharacterModel.fromJson(body.cast<String, dynamic>());
      }
      throw DioException(
        requestOptions: res.requestOptions,
        error: 'Character not found',
      );
    } catch (_) {
      final cached = _getFreshCache(key);
      if (cached is List && cached.isNotEmpty) {
        return CharacterModel.fromJson(
          (cached.first as Map).cast<String, dynamic>(),
        );
      } else if (cached is Map) {
        return CharacterModel.fromJson(cached.cast<String, dynamic>());
      }
      rethrow;
    }
  }

  @override
  Future<List<CharacterModel>> getCharactersByHouse(String house) async {
    final h = house.trim().toLowerCase();
    final key = 'characters_house_$h';
    try {
      final res = await dio.get('${Endpoints.charactersByHouse}/$h');
      _putCache(key, res.data);
      final data = (res.data as List).cast<Map<String, dynamic>>();
      return data.map(CharacterModel.fromJson).toList();
    } catch (_) {
      final cached = _getFreshCache<List>(key);
      if (cached is List) {
        final data = cached.cast<Map>().cast<Map<String, dynamic>>();
        return data.map(CharacterModel.fromJson).toList();
      }
      rethrow;
    }
  }
}
