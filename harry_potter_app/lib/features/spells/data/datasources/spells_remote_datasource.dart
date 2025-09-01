import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/network/endpoints.dart';
import '../models/spell_model.dart';

abstract class SpellsRemoteDataSource {
  Future<List<SpellModel>> getSpells();
}

class SpellsRemoteDataSourceImpl implements SpellsRemoteDataSource {
  final Dio dio;
  SpellsRemoteDataSourceImpl(this.dio);

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
    // Backward compatibility for raw stored list
    return cached as T?;
  }

  @override
  Future<List<SpellModel>> getSpells() async {
    const key = 'spells_all';
    try {
      final res = await dio.get(Endpoints.spells);
      _putCache(key, res.data);
      final data = (res.data as List).cast<Map<String, dynamic>>();
      return data.map(SpellModel.fromJson).toList();
    } catch (_) {
      final cached = _getFreshCache<List>(key);
      if (cached is List) {
        final data = cached.cast<Map>().cast<Map<String, dynamic>>();
        return data.map(SpellModel.fromJson).toList();
      }
      rethrow;
    }
  }
}
