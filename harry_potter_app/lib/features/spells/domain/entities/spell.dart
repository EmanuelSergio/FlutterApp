import 'package:equatable/equatable.dart';

class Spell extends Equatable {
  final String id;
  final String name;
  final String description;
  const Spell({
    required this.name,
    required this.description,
    required this.id,
  });
  @override
  List<Object?> get props => [name, description, id];
}
