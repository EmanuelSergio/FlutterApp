import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../features/characters/presentation/bloc/characters_bloc.dart';
import '../../features/spells/presentation/bloc/spells_bloc.dart';
import '../di/locator.dart';
import '../../features/characters/domain/usecases/get_all_characters.dart';
import '../../features/characters/domain/usecases/get_characters_by_house.dart';
import '../../features/spells/domain/usecases/get_spells.dart';
import 'theme_cubit.dart';
import 'locale_cubit.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CharactersBloc>(
          create: (_) => CharactersBloc(
            getAll: sl<GetAllCharacters>(),
            getByHouse: sl<GetCharactersByHouse>(),
          )..add(const LoadAllCharacters()),
        ),
        BlocProvider<SpellsBloc>(
          create: (_) =>
              SpellsBloc(getSpells: sl<GetSpells>())..add(const LoadSpells()),
        ),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LocaleCubit>(create: (ctx) => LocaleCubit(ctx.locale)),
      ],
      child: child,
    );
  }
}
