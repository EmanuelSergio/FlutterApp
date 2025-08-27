part of 'characters_bloc.dart';

abstract class CharactersEvent extends Equatable {
  const CharactersEvent();
  @override
  List<Object?> get props => [];
}

class LoadAllCharacters extends CharactersEvent {
  const LoadAllCharacters();
}

class LoadCharactersByHouse extends CharactersEvent {
  final String house;
  const LoadCharactersByHouse(this.house);
  @override
  List<Object?> get props => [house];
}

class SearchCharacters extends CharactersEvent {
  final String query;
  const SearchCharacters(this.query);
  @override
  List<Object?> get props => [query];
}
