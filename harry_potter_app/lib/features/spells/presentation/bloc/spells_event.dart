part of 'spells_bloc.dart';

abstract class SpellsEvent extends Equatable {
  const SpellsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSpells extends SpellsEvent {
  const LoadSpells();
}
