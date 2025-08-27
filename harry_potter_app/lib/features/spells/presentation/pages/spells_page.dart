import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/spells_bloc.dart';

class SpellsPage extends StatelessWidget {
  const SpellsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('spells_title'.tr())),
      body: BlocBuilder<SpellsBloc, SpellsState>(
        builder: (context, state) {
          switch (state.status) {
            case SpellsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case SpellsStatus.failure:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        state.error ?? 'error_generic'.tr(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text('retry'.tr()),
                      onPressed: () =>
                          context.read<SpellsBloc>().add(const LoadSpells()),
                    ),
                  ],
                ),
              );
            case SpellsStatus.success:
              if (state.spells.isEmpty)
                return Center(child: Text('empty_list'.tr()));
              return ListView.separated(
                itemCount: state.spells.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final s = state.spells[index];
                  return ListTile(
                    leading: const Icon(Icons.auto_fix_high),
                    title: Text(s.name),
                    subtitle: Text(s.description),
                  );
                },
              );
            case SpellsStatus.initial:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
