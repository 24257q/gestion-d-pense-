import 'package:flutter/material.dart';

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// =============================================================================
// Module: Localizations (i18n)
// Responsabilité: Chaînes FR / EN — changement de langue in-app
// =============================================================================

abstract class AppLocalizations {
  static const supportedLocales = [
    Locale('fr'),
    Locale('en'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations lookup(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizationsEn();
      case 'fr':
      default:
        return AppLocalizationsFr();
    }
  }

  String get languageCode;

  String get appTitle;
  String get income;
  String get expenses;
  String get balance;
  String get transactions;
  String get emptyTransactions;
  String get add;
  String get expensesByCategory;
  String get chartPlaceholder;
  String get addTransaction;
  String get editTransaction;
  String get updateTransaction;
  String get editScreenSubtitle;
  String get addScreenSubtitle;
  String get editTooltip;
  String get deleteTooltip;
  String get incomeType;
  String get expenseType;
  String get titleOptional;
  String get titleHint;
  String get amount;
  String get amountHint;
  String get category;
  String get date;
  String get saveTransaction;
  String get enterAmount;
  String get enterValidAmount;
  String get detailsSection;
  String get pickDateTooltip;
  String get cloudSyncOn;
  String get cloudSyncOff;
  String get loading;
  String get errorGeneric;
  String get retry;
  String get settings;
  String get language;
  String get languageFr;
  String get languageEn;
  String get monthlyBudget;
  String get budgetHint;
  String get budgetProgress;
  String get budgetExceeded;
  String get searchHint;
  String get noSearchResults;
  String get stats;
  String get statsSubtitle;
  String get savingsRate;
  String get topExpenseCategory;
  String get transactionCount;
  String get home;
  String get about;
  String get aboutText;
  String get filterAll;
  String get filterIncome;
  String get filterExpense;
  String get confirmDelete;
  String get cancel;
  String get delete;
  String get darkMode;
  String get lightMode;

  String categoryLabel(String key);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['fr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations.lookup(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
