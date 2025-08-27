part of 'characters_bloc.dart';

enum CharactersStatus { initial, loading, success, failure }

class CharactersState extends Equatable {
  final CharactersStatus status;
  final List<Character> characters;
  final String? selectedHouse;
  final String searchQuery;
  final String? error;

  const CharactersState({
    this.status = CharactersStatus.initial,
    this.characters = const [],
    this.selectedHouse,
    this.searchQuery = '',
    this.error,
  });

  const CharactersState.initial() : this();

  CharactersState copyWith({
    CharactersStatus? status,
    List<Character>? characters,
    String? selectedHouse,
    String? searchQuery,
    String? error,
  }) => CharactersState(
    status: status ?? this.status,
    characters: characters ?? this.characters,
    selectedHouse: selectedHouse ?? this.selectedHouse,
    searchQuery: searchQuery ?? this.searchQuery,
    error: error ?? this.error,
  );

  @override
  List<Object?> get props => [
    status,
    characters,
    selectedHouse,
    searchQuery,
    error,
  ];
}
