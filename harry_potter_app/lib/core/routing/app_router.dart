import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../features/characters/presentation/pages/characters_page.dart';
import '../../features/characters/presentation/pages/character_details_page.dart';
import '../../features/houses/presentation/pages/houses_page.dart';
import '../../features/spells/presentation/pages/spells_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          final locale = context.locale;
          return Scaffold(
            key: ValueKey('shell_${locale.languageCode}'),
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.person),
                  label: 'tab_characters'.tr(),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.shield),
                  label: 'tab_houses'.tr(),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.auto_fix_high),
                  label: 'tab_spells'.tr(),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings),
                  label: 'tab_settings'.tr(),
                ),
              ],
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'characters',
                builder: (context, state) => const CharactersPage(),
                routes: [
                  GoRoute(
                    path: 'character/:id',
                    name: 'character_details',
                    builder: (context, state) => CharacterDetailsPage(
                      id: state.pathParameters['id']!,
                      extra: state.extra,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/houses',
                name: 'houses',
                builder: (context, state) => const HousesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/spells',
                name: 'spells',
                builder: (context, state) => const SpellsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
