import 'transaction_type.dart';

// =============================================================================
// Module: Transaction (MVC — Model)
// Responsabilité: Entité métier — sérialisation JSON / Firestore
// =============================================================================

class Transaction {
  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.categoryKey,
    required this.type,
    DateTime? date,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        date = date ?? DateTime.now();

  final String id;
  final String title;
  final double amount;

  /// Clé de catégorie (ex. `food`, `salary`) — voir [CategoryCatalog].
  final String categoryKey;
  final TransactionType type;
  final DateTime date;

  String displayTitle(String categoryLabel) {
    final t = title.trim();
    if (t.isEmpty) return categoryLabel;
    return t;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': categoryKey,
        'type': type.name,
        'date': date.toIso8601String(),
      };

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      categoryKey: json['category'] as String,
      type: TransactionType.values.byName(json['type'] as String),
      date: DateTime.parse(json['date'] as String),
    );
  }

  Transaction copyWith({
    String? title,
    double? amount,
    String? categoryKey,
    TransactionType? type,
    DateTime? date,
  }) {
    return Transaction(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryKey: categoryKey ?? this.categoryKey,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }
}
