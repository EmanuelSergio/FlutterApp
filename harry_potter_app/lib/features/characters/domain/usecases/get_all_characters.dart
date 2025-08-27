import '../entities/character.dart';
import '../repositories/characters_repository.dart';

class GetAllCharacters {
  final CharactersRepository repo;
  GetAllCharacters(this.repo);
  Future<List<Character>> call() => repo.getAllCharacters();
}
