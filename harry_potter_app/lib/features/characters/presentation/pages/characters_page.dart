import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../design/molecules/character_tile.dart';

import '../bloc/characters_bloc.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('characters_title'.tr())),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  BlocBuilder<CharactersBloc, CharactersState>(
                    buildWhen: (p, n) => p.selectedHouse != n.selectedHouse,
                    builder: (context, state) {
                      final selected = <String>{
                        if (state.selectedHouse != null) state.selectedHouse!,
                      };
                      return SegmentedButton<String>(
                        segments: [
                          ButtonSegment(
                            value: 'gryffindor',
                            label: Text('house_gryffindor'.tr()),
                          ),
                          ButtonSegment(
                            value: 'slytherin',
                            label: Text('house_slytherin'.tr()),
                          ),
                          ButtonSegment(
                            value: 'ravenclaw',
                            label: Text('house_ravenclaw'.tr()),
                          ),
                          ButtonSegment(
                            value: 'hufflepuff',
                            label: Text('house_hufflepuff'.tr()),
                          ),
                        ],
                        selected: selected,
                        emptySelectionAllowed: true,
                        onSelectionChanged: (s) {
                          if (s.isEmpty) {
                            context.read<CharactersBloc>().add(
                              const LoadAllCharacters(),
                            );
                          } else {
                            context.read<CharactersBloc>().add(
                              LoadCharactersByHouse(s.first),
                            );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => context.read<CharactersBloc>().add(
                      const LoadAllCharacters(),
                    ),
                    icon: const Icon(Icons.filter_alt_off),
                    label: Text('all'.tr()),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'search'.tr(),
              ),
              onChanged: (v) =>
                  context.read<CharactersBloc>().add(SearchCharacters(v)),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<CharactersBloc, CharactersState>(
              builder: (context, state) {
                final query = state.searchQuery.toLowerCase();
                final list = query.isEmpty
                    ? state.characters
                    : state.characters
                          .where((c) => c.name.toLowerCase().contains(query))
                          .toList();
                switch (state.status) {
                  case CharactersStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case CharactersStatus.failure:
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              state.error ?? 'error_generic'.tr(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: Text('retry'.tr()),
                            onPressed: () {
                              final h = state.selectedHouse;
                              if (h == null) {
                                context.read<CharactersBloc>().add(
                                  const LoadAllCharacters(),
                                );
                              } else {
                                context.read<CharactersBloc>().add(
                                  LoadCharactersByHouse(h),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  case CharactersStatus.success:
                    if (list.isEmpty)
                      return Center(child: Text('empty_list'.tr()));
                    return ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final c = list[index];
                        return CharacterTile(
                          character: c,
                          onTap: () => context.go('/character/${c.id}'),
                        );
                      },
                    );
                  case CharactersStatus.initial:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
