import '../entities/spell.dart';

abstract class SpellsRepository {
  Future<List<Spell>> getSpells();
}
