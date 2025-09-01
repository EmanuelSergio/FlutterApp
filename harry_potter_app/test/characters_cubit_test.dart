import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:harry_potter_app/features/characters/domain/entities/character.dart';
import 'package:harry_potter_app/features/characters/domain/usecases/get_all_characters.dart';
import 'package:harry_potter_app/features/characters/domain/usecases/get_characters_by_house.dart';
import 'package:harry_potter_app/features/characters/presentation/cubit/characters_cubit.dart';
import 'package:harry_potter_app/features/characters/presentation/cubit/characters_state.dart';
import 'package:harry_potter_app/core/preferences/app_preferences.dart';

class _MockGetAll extends Mock implements GetAllCharacters {}

class _MockGetByHouse extends Mock implements GetCharactersByHouse {}

class _MockPrefs extends Mock implements AppPreferences {}

void main() {
  setUpAll(() {
    registerFallbackValue('gryffindor');
  });

  group('CharactersCubit', () {
    late _MockGetAll getAll;
    late _MockGetByHouse getByHouse;
    late _MockPrefs prefs;
    late CharactersCubit cubit;

    setUp(() {
      getAll = _MockGetAll();
      getByHouse = _MockGetByHouse();
      prefs = _MockPrefs();
      when(() => prefs.getSelectedHouse()).thenReturn(null);
      when(() => prefs.getSearchQuery()).thenReturn('');
      when(() => prefs.setSelectedHouse(any())).thenAnswer((_) async {});
      when(() => prefs.setSearchQuery(any())).thenAnswer((_) async {});
      cubit = CharactersCubit(
        getAll: getAll,
        getByHouse: getByHouse,
        prefs: prefs,
      );
    });

    test('initial state', () {
      expect(cubit.state.status, CharactersStatus.initial);
      expect(cubit.state.characters, isEmpty);
    });

    test('loadAll success', () async {
      when(
        () => getAll(),
      ).thenAnswer((_) async => const [Character(id: '1', name: 'Harry')]);

      await cubit.loadAll();
      expect(cubit.state.status, CharactersStatus.success);
      expect(cubit.state.characters, isNotEmpty);
      verify(() => getAll()).called(1);
      verify(() => prefs.setSelectedHouse(null)).called(1);
      verify(() => prefs.setSearchQuery('')).called(1);
    });

    test('loadByHouse success', () async {
      when(() => getByHouse(any())).thenAnswer(
        (_) async => const [
          Character(id: '2', name: 'Hermione', house: 'gryffindor'),
        ],
      );

      await cubit.loadByHouse('gryffindor');
      expect(cubit.state.status, CharactersStatus.success);
      expect(cubit.state.selectedHouse, 'gryffindor');
      expect(cubit.state.characters.first.house, 'gryffindor');
      verify(() => getByHouse('gryffindor')).called(1);
      verify(() => prefs.setSelectedHouse('gryffindor')).called(1);
      verify(() => prefs.setSearchQuery('')).called(1);
    });

    test('search persists query', () async {
      cubit.search('har');
      expect(cubit.state.searchQuery, 'har');
      verify(() => prefs.setSearchQuery('har')).called(1);
    });

    test('error mapped on failure', () async {
      when(() => getAll()).thenThrow(Exception('boom'));

      await cubit.loadAll();
      expect(cubit.state.status, CharactersStatus.failure);
      expect(cubit.state.error, isNotEmpty);
    });
  });
}
