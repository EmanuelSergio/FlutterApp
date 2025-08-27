import '../entities/character.dart';

abstract class CharactersRepository {
  Future<List<Character>> getAllCharacters();
  Future<List<Character>> getCharactersByHouse(String house);
  Future<Character> getCharacterById(String id);
}
