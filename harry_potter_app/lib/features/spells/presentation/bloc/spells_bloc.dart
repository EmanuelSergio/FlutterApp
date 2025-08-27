import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/spell.dart';
import '../../domain/usecases/get_spells.dart';

part 'spells_event.dart';
part 'spells_state.dart';

class SpellsBloc extends Bloc<SpellsEvent, SpellsState> {
  final GetSpells getSpells;
  SpellsBloc({required this.getSpells}) : super(const SpellsState.initial()) {
    on<LoadSpells>((event, emit) async {
      emit(state.copyWith(status: SpellsStatus.loading));
      try {
        final list = await getSpells();
        emit(state.copyWith(status: SpellsStatus.success, spells: list));
      } catch (e) {
        emit(state.copyWith(status: SpellsStatus.failure, error: e.toString()));
      }
    });
  }
}
