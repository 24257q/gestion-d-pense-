import 'transaction_type.dart';

/// Predefined category labels (Arabic) for income and expenses.
class CategoryCatalog {
  CategoryCatalog._();

  static const List<String> expense = [
    'طعام',
    'مواصلات',
    'فواتير',
    'تسوق',
    'ترفيه',
    'صحة',
    'أخرى',
  ];

  static const List<String> income = [
    'راتب',
    'عمل حر',
    'استثمار',
    'هدية',
    'أخرى',
  ];

  static List<String> forType(TransactionType type) =>
      type == TransactionType.income ? income : expense;
}
