import '../../domain/entities/character.dart';
import '../models/character_model.dart';

extension CharacterMapper on CharacterModel {
  Character toEntity() => Character(
    id: id,
    name: name,
    house: house,
    patronus: patronus,
    species: species,
    ancestry: ancestry,
    dateOfBirth: dateOfBirth,
    image: image,
  );
}
