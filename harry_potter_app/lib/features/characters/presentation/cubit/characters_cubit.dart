import 'package:bloc/bloc.dart';

import '../../domain/usecases/get_all_characters.dart';
import '../../domain/usecases/get_characters_by_house.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/preferences/app_preferences.dart';
import 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final GetAllCharacters getAll;
  final GetCharactersByHouse getByHouse;
  final AppPreferences prefs;

  CharactersCubit({
    required this.getAll,
    required this.getByHouse,
    required this.prefs,
  }) : super(const CharactersState.initial());

  Future<void> restore() async {
    final house = prefs.getSelectedHouse();
    final q = prefs.getSearchQuery();
    if (house == null) {
      await loadAll();
    } else {
      await loadByHouse(house);
    }
    if (q.isNotEmpty) {
      emit(state.copyWith(searchQuery: q));
    }
  }

  Future<void> loadAll() async {
    emit(
      state.copyWith(
        status: CharactersStatus.loading,
        selectedHouse: null,
        searchQuery: '',
      ),
    );
    try {
      final list = await getAll();
      await prefs.setSelectedHouse(null);
      await prefs.setSearchQuery('');
      emit(
        state.copyWith(
          status: CharactersStatus.success,
          characters: list,
          selectedHouse: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CharactersStatus.failure,
          error: mapErrorToKey(e),
        ),
      );
    }
  }

  Future<void> loadByHouse(String house) async {
    emit(
      state.copyWith(
        status: CharactersStatus.loading,
        selectedHouse: house,
        searchQuery: '',
      ),
    );
    try {
      final list = await getByHouse(house);
      await prefs.setSelectedHouse(house);
      await prefs.setSearchQuery('');
      emit(state.copyWith(status: CharactersStatus.success, characters: list));
    } catch (e) {
      emit(
        state.copyWith(
          status: CharactersStatus.failure,
          error: mapErrorToKey(e),
        ),
      );
    }
  }

  void search(String query) {
    prefs.setSearchQuery(query);
    emit(state.copyWith(searchQuery: query));
  }
}
