part of 'character_model.dart';

CharacterModel _$CharacterModelFromJson(Map<String, dynamic> json) =>
    CharacterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      house: json['house'] as String?,
      patronus: json['patronus'] as String?,
      species: json['species'] as String?,
      ancestry: json['ancestry'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$CharacterModelToJson(CharacterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'house': instance.house,
      'patronus': instance.patronus,
      'species': instance.species,
      'ancestry': instance.ancestry,
      'dateOfBirth': instance.dateOfBirth,
      'image': instance.image,
    };
