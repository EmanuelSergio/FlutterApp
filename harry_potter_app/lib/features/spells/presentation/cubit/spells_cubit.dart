import 'package:bloc/bloc.dart';

import '../../domain/usecases/get_spells.dart';
import '../../../../core/error/error_mapper.dart';
import 'spells_state.dart';

class SpellsCubit extends Cubit<SpellsState> {
  final GetSpells getSpells;
  SpellsCubit({required this.getSpells}) : super(const SpellsState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: SpellsStatus.loading));
    try {
      final list = await getSpells();
      emit(state.copyWith(status: SpellsStatus.success, spells: list));
    } catch (e) {
      emit(
        state.copyWith(status: SpellsStatus.failure, error: mapErrorToKey(e)),
      );
    }
  }
}
