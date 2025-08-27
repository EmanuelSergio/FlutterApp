import 'package:equatable/equatable.dart';

class Character extends Equatable {
  final String id;
  final String name;
  final String? house;
  final String? patronus;
  final String? species;
  final String? ancestry;
  final String? dateOfBirth;
  final String? image;

  const Character({
    required this.id,
    required this.name,
    this.house,
    this.patronus,
    this.species,
    this.ancestry,
    this.dateOfBirth,
    this.image,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    house,
    patronus,
    species,
    ancestry,
    dateOfBirth,
    image,
  ];
}
