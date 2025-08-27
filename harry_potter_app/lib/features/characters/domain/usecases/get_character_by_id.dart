import '../entities/character.dart';
import '../repositories/characters_repository.dart';

class GetCharacterById {
  final CharactersRepository repo;
  GetCharacterById(this.repo);
  Future<Character> call(String id) => repo.getCharacterById(id);
}
