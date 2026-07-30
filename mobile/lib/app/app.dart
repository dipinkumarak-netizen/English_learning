import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/app_config.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'router/app_router.dart';

final localeProvider = StateNotifierProvider<LocaleController, Locale>(
  (ref) => LocaleController(),
);

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('ml')) {
    _load();
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final code = preferences.getString('application_language');
    if (code == 'en' || code == 'ml') state = Locale(code!);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await (await SharedPreferences.getInstance()).setString(
      'application_language',
      locale.languageCode,
    );
  }
}

class NilaSpeakApp extends ConsumerWidget {
  const NilaSpeakApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
