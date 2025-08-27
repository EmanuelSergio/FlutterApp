import 'package:dio/dio.dart';
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

  @override
  Future<List<CharacterModel>> getAllCharacters() async {
    final res = await dio.get(Endpoints.characters);
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(CharacterModel.fromJson).toList();
  }

  @override
  Future<CharacterModel> getCharacterById(String id) async {
    final res = await dio.get('${Endpoints.characterById}/$id');
    final body = res.data;
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
  }

  @override
  Future<List<CharacterModel>> getCharactersByHouse(String house) async {
    final h = house.trim().toLowerCase();
    final res = await dio.get('${Endpoints.charactersByHouse}/$h');
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(CharacterModel.fromJson).toList();
  }
}
