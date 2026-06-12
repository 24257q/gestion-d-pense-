import 'package:flutter/material.dart';
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

  static IconData getIcon(String key) {
    switch (key) {
      case 'food': return Icons.restaurant_rounded;
      case 'transport': return Icons.directions_car_rounded;
      case 'bills': return Icons.receipt_long_rounded;
      case 'shopping': return Icons.shopping_bag_rounded;
      case 'entertainment': return Icons.movie_rounded;
      case 'health': return Icons.favorite_rounded;
      case 'salary': return Icons.payments_rounded;
      case 'freelance': return Icons.computer_rounded;
      case 'investment': return Icons.trending_up_rounded;
      case 'gift': return Icons.card_giftcard_rounded;
      case 'other':
      default:
        return Icons.category_rounded;
    }
  }

  static Color getColor(String key) {
    switch (key) {
      case 'food': return const Color(0xFFF59E0B);
      case 'transport': return const Color(0xFF3B82F6);
      case 'bills': return const Color(0xFFEF4444);
      case 'shopping': return const Color(0xFFA855F7);
      case 'entertainment': return const Color(0xFFEC4899);
      case 'health': return const Color(0xFF14B8A6);
      case 'salary': return const Color(0xFF10B981);
      case 'freelance': return const Color(0xFF06B6D4);
      case 'investment': return const Color(0xFF8B5CF6);
      case 'gift': return const Color(0xFFF43F5E);
      case 'other':
      default:
        return const Color(0xFF64748B);
    }
  }
}

