import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/locator.dart';
import 'core/routing/app_router.dart';
import 'core/app/app_providers.dart';
import 'core/theme/app_theme.dart';
import 'core/app/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupLocator();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('pt')],
      path: 'assets/translations',
      fallbackLocale: const Locale('pt'),
      useOnlyLangCode: true,
      child: AppProviders(child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter();

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final locale = context.locale; // trigger rebuild on locale change
        return MaterialApp.router(
          key: ValueKey('app_${locale.languageCode}'),
          debugShowCheckedModeBanner: false,
          title: 'app_title'.tr(),
          routerConfig: router,
          themeMode: themeMode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,
        );
      },
    );
  }
}
