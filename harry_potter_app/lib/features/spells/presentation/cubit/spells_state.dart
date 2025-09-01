import 'package:equatable/equatable.dart';
import '../../domain/entities/spell.dart';

enum SpellsStatus { initial, loading, success, failure }

class SpellsState extends Equatable {
  final SpellsStatus status;
  final List<Spell> spells;
  final String? error;

  const SpellsState({
    this.status = SpellsStatus.initial,
    this.spells = const [],
    this.error,
  });
  const SpellsState.initial() : this();

  SpellsState copyWith({
    SpellsStatus? status,
    List<Spell>? spells,
    String? error,
  }) => SpellsState(
    status: status ?? this.status,
    spells: spells ?? this.spells,
    error: error ?? this.error,
  );

  @override
  List<Object?> get props => [status, spells, error];
}
