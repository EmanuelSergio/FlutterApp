import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../features/characters/presentation/cubit/characters_cubit.dart';
import '../../features/spells/presentation/cubit/spells_cubit.dart';
import '../di/locator.dart';
import '../../features/characters/domain/usecases/get_all_characters.dart';
import '../../features/characters/domain/usecases/get_characters_by_house.dart';
import '../../features/spells/domain/usecases/get_spells.dart';
import 'theme_cubit.dart';
import 'locale_cubit.dart';
import '../preferences/app_preferences.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CharactersCubit>(
          create: (_) => CharactersCubit(
            getAll: sl<GetAllCharacters>(),
            getByHouse: sl<GetCharactersByHouse>(),
            prefs: sl<AppPreferences>(),
          )..restore(),
        ),
        BlocProvider<SpellsCubit>(
          create: (_) => SpellsCubit(getSpells: sl<GetSpells>())..load(),
        ),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LocaleCubit>(create: (ctx) => LocaleCubit(ctx.locale)),
      ],
      child: child,
    );
  }
}
