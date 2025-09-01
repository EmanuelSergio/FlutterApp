import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:harry_potter_app/features/characters/data/datasources/characters_remote_datasource.dart';
import 'package:harry_potter_app/features/characters/data/repositories/characters_repository_impl.dart';
import 'package:harry_potter_app/features/characters/data/models/character_model.dart';

class _MockRemote extends Mock implements CharactersRemoteDataSource {}

void main() {
  test('getAllCharacters caches result', () async {
    final remote = _MockRemote();
    final repo = CharactersRepositoryImpl(remote);
    when(
      () => remote.getAllCharacters(),
    ).thenAnswer((_) async => [const CharacterModel(id: '1', name: 'Harry')]);

    final first = await repo.getAllCharacters();
    final second = await repo.getAllCharacters();

    expect(first, isNotEmpty);
    expect(identical(first, second), isTrue);
    verify(() => remote.getAllCharacters()).called(1);
  });
}
