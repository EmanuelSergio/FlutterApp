import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:harry_potter_app/features/spells/domain/entities/spell.dart';
import 'package:harry_potter_app/features/spells/domain/usecases/get_spells.dart';
import 'package:harry_potter_app/features/spells/presentation/cubit/spells_cubit.dart';
import 'package:harry_potter_app/features/spells/presentation/cubit/spells_state.dart';

class _MockGetSpells extends Mock implements GetSpells {}

void main() {
  group('SpellsCubit', () {
    late _MockGetSpells getSpells;
    late SpellsCubit cubit;

    setUp(() {
      getSpells = _MockGetSpells();
      cubit = SpellsCubit(getSpells: getSpells);
    });

    test('initial state', () {
      expect(cubit.state.status, SpellsStatus.initial);
      expect(cubit.state.spells, isEmpty);
    });

    test('load success', () async {
      when(() => getSpells()).thenAnswer(
        (_) async => const [
          Spell(id: '1', name: 'Expelliarmus', description: 'Disarming Charm'),
        ],
      );

      await cubit.load();
      expect(cubit.state.status, SpellsStatus.success);
      expect(cubit.state.spells, isNotEmpty);
      verify(() => getSpells()).called(1);
    });

    test('error mapped on failure', () async {
      when(() => getSpells()).thenThrow(Exception('boom'));

      await cubit.load();
      expect(cubit.state.status, SpellsStatus.failure);
      expect(cubit.state.error, isNotEmpty);
    });
  });
}
