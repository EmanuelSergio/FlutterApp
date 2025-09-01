import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:harry_potter_app/design/molecules/error_view.dart';
import '../cubit/spells_cubit.dart';
import '../cubit/spells_state.dart';

class SpellsPage extends StatelessWidget {
  const SpellsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('spells_title'.tr())),
      body: BlocBuilder<SpellsCubit, SpellsState>(
        builder: (context, state) {
          switch (state.status) {
            case SpellsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case SpellsStatus.failure:
              return ErrorView(
                messageKey: (state.error ?? 'error_generic'),
                onRetry: () => context.read<SpellsCubit>().load(),
              );
            case SpellsStatus.success:
              if (state.spells.isEmpty) {
                return Center(child: Text('empty_list'.tr()));
              }
              return RefreshIndicator(
                onRefresh: () => context.read<SpellsCubit>().load(),
                child: ListView.separated(
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
                ),
              );
            case SpellsStatus.initial:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
