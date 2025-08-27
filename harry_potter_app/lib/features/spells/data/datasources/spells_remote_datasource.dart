import 'package:dio/dio.dart';
import '../../../../core/network/endpoints.dart';
import '../models/spell_model.dart';

abstract class SpellsRemoteDataSource {
  Future<List<SpellModel>> getSpells();
}

class SpellsRemoteDataSourceImpl implements SpellsRemoteDataSource {
  final Dio dio;
  SpellsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<SpellModel>> getSpells() async {
    final res = await dio.get(Endpoints.spells);
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(SpellModel.fromJson).toList();
  }
}
