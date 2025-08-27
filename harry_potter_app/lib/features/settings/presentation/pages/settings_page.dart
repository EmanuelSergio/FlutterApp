import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app/theme_cubit.dart';
import '../../../../core/app/locale_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeCubit>().state;
    final locales = context.supportedLocales;
    final currentLocale = context.locale;

    return Scaffold(
      appBar: AppBar(title: Text('tab_settings'.tr())),
      body: ListView(
        children: [
          ListTile(
            title: Text('theme'.tr()),
            subtitle: Text(_themeLabel(theme).tr()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('theme_system'.tr()),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('theme_light'.tr()),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('theme_dark'.tr()),
                ),
              ],
              selected: {theme},
              onSelectionChanged: (s) =>
                  context.read<ThemeCubit>().setThemeMode(s.first),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text('language'.tr()),
            subtitle: Text(currentLocale.languageCode.toUpperCase()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<Locale>(
              segments: locales
                  .map(
                    (l) => ButtonSegment(
                      value: l,
                      label: Text(l.languageCode.toUpperCase()),
                    ),
                  )
                  .toList(),
              selected: {currentLocale},
              onSelectionChanged: (s) async {
                final l = s.first;
                await context.setLocale(l);
                context.read<LocaleCubit>().setLocale(l);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode m) {
    switch (m) {
      case ThemeMode.system:
        return 'theme_system';
      case ThemeMode.light:
        return 'theme_light';
      case ThemeMode.dark:
        return 'theme_dark';
    }
  }
}
