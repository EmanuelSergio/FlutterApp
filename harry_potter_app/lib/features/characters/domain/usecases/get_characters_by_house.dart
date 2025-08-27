import '../entities/character.dart';
import '../repositories/characters_repository.dart';

class GetCharactersByHouse {
  final CharactersRepository repo;
  GetCharactersByHouse(this.repo);
  Future<List<Character>> call(String house) =>
      repo.getCharactersByHouse(house);
}
