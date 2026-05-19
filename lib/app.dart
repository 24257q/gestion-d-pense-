import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'controllers/locale_controller.dart';
import 'controllers/theme_controller.dart';
import 'core/navigation/app_shell.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

class ExpenseManagerApp extends StatelessWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleController>().locale;
    final themeMode = context.watch<ThemeController>().mode;

    return MaterialApp(
      title: 'Expense Manager',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const AppShell(),
    );
  }
}
