import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../l10n/app_localizations.dart';

// =============================================================================
// Module: Locale Controller (MVC — Controller / Provider)
// Responsabilité: Langue FR / EN persistante
// =============================================================================

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(AppConstants.prefsLocaleKey);
    if (code != null && ['fr', 'en'].contains(code)) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales
        .any((l) => l.languageCode == locale.languageCode)) {
      return;
    }
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefsLocaleKey, locale.languageCode);
  }

  void toggleLanguage() {
    final next = _locale.languageCode == 'fr'
        ? const Locale('en')
        : const Locale('fr');
    setLocale(next);
  }
}
