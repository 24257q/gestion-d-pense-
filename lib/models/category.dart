import 'transaction_type.dart';

class CategoryCatalog {
  CategoryCatalog._();

  static const List<String> expense = [
    'food',
    'transport',
    'bills',
    'shopping',
    'entertainment',
    'health',
    'other',
  ];

  static const List<String> income = [
    'salary',
    'freelance',
    'investment',
    'gift',
    'other',
  ];

  static List<String> forType(TransactionType type) =>
      type == TransactionType.income ? income : expense;
}
