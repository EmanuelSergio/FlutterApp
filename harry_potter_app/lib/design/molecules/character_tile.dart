import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../features/characters/domain/entities/character.dart';
import '../atoms/hp_avatar.dart';

class CharacterTile extends StatelessWidget {
  final Character character;
  final VoidCallback? onTap;
  const CharacterTile({super.key, required this.character, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: 'character_${character.id}',
        child: HPAvatar(imageUrl: character.image, label: character.name),
      ),
      title: Text(character.name),
      subtitle: Text(character.house ?? 'unknown'.tr()),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
