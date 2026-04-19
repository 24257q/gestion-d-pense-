import 'transaction_type.dart';

class Transaction {
  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    DateTime? date,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        date = date ?? DateTime.now();

  final String id;
  final String title;
  final double amount;
  final String category;
  final TransactionType type;
  final DateTime date;

  String get displayTitle {
    final t = title.trim();
    if (t.isEmpty) return category;
    return t;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category,
        'type': type.name,
        'date': date.toIso8601String(),
      };

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      type: TransactionType.values.byName(json['type'] as String),
      date: DateTime.parse(json['date'] as String),
    );
  }
}
