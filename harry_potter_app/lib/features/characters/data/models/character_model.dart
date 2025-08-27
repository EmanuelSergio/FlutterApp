part 'character_model.g.dart';

class CharacterModel {
  final String id;
  final String name;
  final String? house;
  final String? patronus;
  final String? species;
  final String? ancestry;
  final String? dateOfBirth;
  final String? image;

  const CharacterModel({
    required this.id,
    required this.name,
    this.house,
    this.patronus,
    this.species,
    this.ancestry,
    this.dateOfBirth,
    this.image,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);
}
