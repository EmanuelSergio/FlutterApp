class SpellModel {
  final String name;
  final String description;
  SpellModel({required this.name, required this.description});

  factory SpellModel.fromJson(Map<String, dynamic> json) => SpellModel(
    name: (json['name'] ?? '').toString(),
    description: (json['description'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {'name': name, 'description': description};
}
