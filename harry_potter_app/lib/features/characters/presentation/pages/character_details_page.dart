import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/usecases/get_character_by_id.dart';
import '../../domain/entities/character.dart';
import '../../../../core/di/locator.dart';
import '../../../../design/atoms/hp_avatar.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../design/molecules/error_view.dart';

class CharacterDetailsPage extends StatefulWidget {
  final String id;
  final Object? extra;
  const CharacterDetailsPage({super.key, required this.id, this.extra});

  @override
  State<CharacterDetailsPage> createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage> {
  Character? character;
  String? error;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final result = await sl<GetCharacterById>()(widget.id);
      setState(() {
        character = result;
        loading = false;
        error = null;
      });
    } catch (e) {
      setState(() {
        error = mapErrorToKey(e);
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null)
      return Scaffold(
        appBar: AppBar(),
        body: ErrorView(messageKey: (error ?? 'error_generic'), onRetry: _load),
      );

    final c = character!;
    return Scaffold(
      appBar: AppBar(title: Text(c.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Hero(
              tag: 'character_${c.id}',
              child: HPAvatar(imageUrl: c.image, label: c.name, radius: 48),
            ),
          ),
          const SizedBox(height: 16),
          _tile('house'.tr(), c.house ?? 'unknown'.tr()),
          _tile('patronus'.tr(), c.patronus ?? 'unknown'.tr()),
          _tile('species'.tr(), c.species ?? 'unknown'.tr()),
          _tile('ancestry'.tr(), c.ancestry ?? 'unknown'.tr()),
          _tile('born'.tr(), c.dateOfBirth ?? 'unknown'.tr()),
        ],
      ),
    );
  }

  Widget _tile(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
