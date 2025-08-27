import '../datasources/spells_remote_datasource.dart';
import '../mappers/spell_mapper.dart';
import '../../domain/entities/spell.dart';
import '../../domain/repositories/spells_repository.dart';

class SpellsRepositoryImpl implements SpellsRepository {
  final SpellsRemoteDataSource remote;
  SpellsRepositoryImpl(this.remote);
  @override
  Future<List<Spell>> getSpells() async {
    final list = await remote.getSpells();
    return list.map((e) => e.toEntity()).toList();
  }
}
