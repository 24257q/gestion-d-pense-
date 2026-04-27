import 'app_ar.dart';
import 'app_en.dart';
import 'app_fr.dart';

abstract final class AppStrings {
  static String currentLang = 'ar';

  static String get appTitle {
    switch (currentLang) {
      case 'en':
        return AppEn.appTitle;
      case 'fr':
        return AppFr.appTitle;
      default:
        return AppAr.appTitle;
    }
  }

  static String get income {
    switch (currentLang) {
      case 'en':
        return AppEn.income;
      case 'fr':
        return AppFr.income;
      default:
        return AppAr.income;
    }
  }

  static String get expenses {
    switch (currentLang) {
      case 'en':
        return AppEn.expenses;
      case 'fr':
        return AppFr.expenses;
      default:
        return AppAr.expenses;
    }
  }

  static String get balance {
    switch (currentLang) {
      case 'en':
        return AppEn.balance;
      case 'fr':
        return AppFr.balance;
      default:
        return AppAr.balance;
    }
  }

  static String get transactions {
    switch (currentLang) {
      case 'en':
        return AppEn.transactions;
      case 'fr':
        return AppFr.transactions;
      default:
        return AppAr.transactions;
    }
  }

  static String get emptyTransactions {
    switch (currentLang) {
      case 'en':
        return AppEn.emptyTransactions;
      case 'fr':
        return AppFr.emptyTransactions;
      default:
        return AppAr.emptyTransactions;
    }
  }

  static String get add {
    switch (currentLang) {
      case 'en':
        return AppEn.add;
      case 'fr':
        return AppFr.add;
      default:
        return AppAr.add;
    }
  }

  static String get editTooltip {
    switch (currentLang) {
      case 'en':
        return AppEn.editTooltip;
      case 'fr':
        return AppFr.editTooltip;
      default:
        return AppAr.editTooltip;
    }
  }

  static String get cloudSyncOn {
    switch (currentLang) {
      case 'en':
        return AppEn.cloudSyncOn;
      case 'fr':
        return AppFr.cloudSyncOn;
      default:
        return AppAr.cloudSyncOn;
    }
  }

  static String get cloudSyncOff {
    switch (currentLang) {
      case 'en':
        return AppEn.cloudSyncOff;
      case 'fr':
        return AppFr.cloudSyncOff;
      default:
        return AppAr.cloudSyncOff;
    }
  }

  static String get editTransaction {
    switch (currentLang) {
      case 'en':
        return AppEn.editTransaction;
      case 'fr':
        return AppFr.editTransaction;
      default:
        return AppAr.editTransaction;
    }
  }

  static String get addTransaction {
    switch (currentLang) {
      case 'en':
        return AppEn.addTransaction;
      case 'fr':
        return AppFr.addTransaction;
      default:
        return AppAr.addTransaction;
    }
  }

  static String get editScreenSubtitle {
    switch (currentLang) {
      case 'en':
        return AppEn.editScreenSubtitle;
      case 'fr':
        return AppFr.editScreenSubtitle;
      default:
        return AppAr.editScreenSubtitle;
    }
  }

  static String get addScreenSubtitle {
    switch (currentLang) {
      case 'en':
        return AppEn.addScreenSubtitle;
      case 'fr':
        return AppFr.addScreenSubtitle;
      default:
        return AppAr.addScreenSubtitle;
    }
  }

  static String get incomeType {
    switch (currentLang) {
      case 'en':
        return AppEn.incomeType;
      case 'fr':
        return AppFr.incomeType;
      default:
        return AppAr.incomeType;
    }
  }

  static String get expenseType {
    switch (currentLang) {
      case 'en':
        return AppEn.expenseType;
      case 'fr':
        return AppFr.expenseType;
      default:
        return AppAr.expenseType;
    }
  }

  static String get detailsSection {
    switch (currentLang) {
      case 'en':
        return AppEn.detailsSection;
      case 'fr':
        return AppFr.detailsSection;
      default:
        return AppAr.detailsSection;
    }
  }

  static String get titleOptional {
    switch (currentLang) {
      case 'en':
        return AppEn.titleOptional;
      case 'fr':
        return AppFr.titleOptional;
      default:
        return AppAr.titleOptional;
    }
  }

  static String get titleHint {
    switch (currentLang) {
      case 'en':
        return AppEn.titleHint;
      case 'fr':
        return AppFr.titleHint;
      default:
        return AppAr.titleHint;
    }
  }

  static String get amount {
    switch (currentLang) {
      case 'en':
        return AppEn.amount;
      case 'fr':
        return AppFr.amount;
      default:
        return AppAr.amount;
    }
  }

  static String get amountHint {
    switch (currentLang) {
      case 'en':
        return AppEn.amountHint;
      case 'fr':
        return AppFr.amountHint;
      default:
        return AppAr.amountHint;
    }
  }

  static String get category {
    switch (currentLang) {
      case 'en':
        return AppEn.category;
      case 'fr':
        return AppFr.category;
      default:
        return AppAr.category;
    }
  }

  static String get enterAmount {
    switch (currentLang) {
      case 'en':
        return AppEn.enterAmount;
      case 'fr':
        return AppFr.enterAmount;
      default:
        return AppAr.enterAmount;
    }
  }

  static String get enterValidAmount {
    switch (currentLang) {
      case 'en':
        return AppEn.enterValidAmount;
      case 'fr':
        return AppFr.enterValidAmount;
      default:
        return AppAr.enterValidAmount;
    }
  }

  static String get date {
    switch (currentLang) {
      case 'en':
        return AppEn.date;
      case 'fr':
        return AppFr.date;
      default:
        return AppAr.date;
    }
  }

  static String get pickDateTooltip {
    switch (currentLang) {
      case 'en':
        return AppEn.pickDateTooltip;
      case 'fr':
        return AppFr.pickDateTooltip;
      default:
        return AppAr.pickDateTooltip;
    }
  }

  static String get updateTransaction {
    switch (currentLang) {
      case 'en':
        return AppEn.updateTransaction;
      case 'fr':
        return AppFr.updateTransaction;
      default:
        return AppAr.updateTransaction;
    }
  }

  static String get saveTransaction {
    switch (currentLang) {
      case 'en':
        return AppEn.saveTransaction;
      case 'fr':
        return AppFr.saveTransaction;
      default:
        return AppAr.saveTransaction;
    }
  }
  static String categoryName(String key) {
    switch (key) {
      case 'food':
        return currentLang == 'en'
            ? 'Food'
            : currentLang == 'fr'
            ? 'Nourriture'
            : 'طعام';

      case 'transport':
        return currentLang == 'en'
            ? 'Transport'
            : currentLang == 'fr'
            ? 'Transport'
            : 'مواصلات';

      case 'bills':
        return currentLang == 'en'
            ? 'Bills'
            : currentLang == 'fr'
            ? 'Factures'
            : 'فواتير';

      case 'shopping':
        return currentLang == 'en'
            ? 'Shopping'
            : currentLang == 'fr'
            ? 'Shopping'
            : 'تسوق';

      case 'entertainment':
        return currentLang == 'en'
            ? 'Entertainment'
            : currentLang == 'fr'
            ? 'Divertissement'
            : 'ترفيه';

      case 'health':
        return currentLang == 'en'
            ? 'Health'
            : currentLang == 'fr'
            ? 'Santé'
            : 'صحة';

      case 'salary':
        return currentLang == 'en'
            ? 'Salary'
            : currentLang == 'fr'
            ? 'Salaire'
            : 'راتب';

      case 'freelance':
        return currentLang == 'en'
            ? 'Freelance'
            : currentLang == 'fr'
            ? 'Freelance'
            : 'عمل حر';

      case 'investment':
        return currentLang == 'en'
            ? 'Investment'
            : currentLang == 'fr'
            ? 'Investissement'
            : 'استثمار';

      case 'gift':
        return currentLang == 'en'
            ? 'Gift'
            : currentLang == 'fr'
            ? 'Cadeau'
            : 'هدية';

      case 'other':
        return currentLang == 'en'
            ? 'Other'
            : currentLang == 'fr'
            ? 'Autre'
            : 'أخرى';

      default:
        return key;
    }
  }

  static String get chartPlaceholder {
    switch (currentLang) {
      case 'en':
        return AppEn.chartPlaceholder;
      case 'fr':
        return AppFr.chartPlaceholder;
      default:
        return AppAr.chartPlaceholder;
    }
  }

  static String get expensesByCategory {
    switch (currentLang) {
      case 'en':
        return AppEn.expensesByCategory;
      case 'fr':
        return AppFr.expensesByCategory;
      default:
        return AppAr.expensesByCategory;
    }
  }
}



