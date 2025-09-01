import '../../domain/entities/spell.dart';
import '../models/spell_model.dart';

extension SpellMapper on SpellModel {
  Spell toEntity() => Spell(name: name, description: description, id: '');
}
