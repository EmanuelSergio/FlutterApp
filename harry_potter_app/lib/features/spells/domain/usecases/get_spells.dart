import '../entities/spell.dart';
import '../repositories/spells_repository.dart';

class GetSpells {
  final SpellsRepository repo;
  GetSpells(this.repo);
  Future<List<Spell>> call() => repo.getSpells();
}
