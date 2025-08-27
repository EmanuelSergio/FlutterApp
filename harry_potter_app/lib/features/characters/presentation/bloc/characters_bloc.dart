import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/character.dart';
import '../../domain/usecases/get_all_characters.dart';
import '../../domain/usecases/get_characters_by_house.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final GetAllCharacters getAll;
  final GetCharactersByHouse getByHouse;

  CharactersBloc({required this.getAll, required this.getByHouse})
    : super(const CharactersState.initial()) {
    on<LoadAllCharacters>((event, emit) async {
      emit(
        state.copyWith(
          status: CharactersStatus.loading,
          selectedHouse: null,
          searchQuery: '',
        ),
      );
      try {
        final list = await getAll();
        emit(
          state.copyWith(
            status: CharactersStatus.success,
            characters: list,
            selectedHouse: null,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(status: CharactersStatus.failure, error: e.toString()),
        );
      }
    });

    on<LoadCharactersByHouse>((event, emit) async {
      emit(
        state.copyWith(
          status: CharactersStatus.loading,
          selectedHouse: event.house,
          searchQuery: '',
        ),
      );
      try {
        final list = await getByHouse(event.house);
        emit(
          state.copyWith(status: CharactersStatus.success, characters: list),
        );
      } catch (e) {
        emit(
          state.copyWith(status: CharactersStatus.failure, error: e.toString()),
        );
      }
    });

    on<SearchCharacters>((event, emit) async {
      emit(state.copyWith(searchQuery: event.query));
    });
  }
}
