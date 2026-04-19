enum TransactionType {
  income,
  expense;

  String get label => switch (this) {
        TransactionType.income => 'دخل',
        TransactionType.expense => 'مصروف',
      };
}
