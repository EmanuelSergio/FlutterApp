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

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
    id: (json['id'] ?? json['_id'] ?? '').toString(),
    name: (json['name'] ?? '').toString(),
    house: json['house'] as String?,
    patronus: json['patronus'] as String?,
    species: json['species'] as String?,
    ancestry: json['ancestry'] as String?,
    dateOfBirth: (json['dateOfBirth'] ?? json['born']) as String?,
    image: json['image'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'house': house,
    'patronus': patronus,
    'species': species,
    'ancestry': ancestry,
    'dateOfBirth': dateOfBirth,
    'image': image,
  };
}
