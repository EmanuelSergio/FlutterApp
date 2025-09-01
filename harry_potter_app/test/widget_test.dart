import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:harry_potter_app/core/app/theme_cubit.dart';
import 'package:harry_potter_app/core/app/locale_cubit.dart';

void main() {
  test('ThemeCubit toggles theme mode', () {
    final cubit = ThemeCubit();
    expect(cubit.state, ThemeMode.system);
    cubit.setThemeMode(ThemeMode.dark);
    expect(cubit.state, ThemeMode.dark);
    cubit.setThemeMode(ThemeMode.light);
    expect(cubit.state, ThemeMode.light);
  });

  test('LocaleCubit updates locale', () {
    final cubit = LocaleCubit(const Locale('en'));
    expect(cubit.state, const Locale('en'));
    cubit.setLocale(const Locale('pt'));
    expect(cubit.state, const Locale('pt'));
  });
}
