import 'transaction_type.dart';

// =============================================================================
// Module: Category (MVC — Model)
// Responsabilité: Clés de catégories stables pour l’i18n et le stockage
// =============================================================================

/// Catalogue de catégories par clé (affichage via [AppLocalizations]).
abstract final class CategoryCatalog {
  CategoryCatalog._();

  static const List<String> expenseKeys = [
    'food',
    'transport',
    'bills',
    'shopping',
    'entertainment',
    'health',
    'other',
  ];

  static const List<String> incomeKeys = [
    'salary',
    'freelance',
    'investment',
    'gift',
    'other_income',
  ];

  static List<String> keysForType(TransactionType type) =>
      type == TransactionType.income ? incomeKeys : expenseKeys;

  static bool isValidKey(TransactionType type, String key) =>
      keysForType(type).contains(key);

  /// Anciennes données (libellés arabes) → clés i18n stables.
  static const Map<String, String> _legacyKeys = {
    'طعام': 'food',
    'مواصلات': 'transport',
    'فواتير': 'bills',
    'تسوق': 'shopping',
    'ترفيه': 'entertainment',
    'صحة': 'health',
    'أخرى': 'other',
    'راتب': 'salary',
    'عمل حر': 'freelance',
    'استثمار': 'investment',
    'هدية': 'gift',
  };

  static String normalizeKey(String key) => _legacyKeys[key] ?? key;
}
