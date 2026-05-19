import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../models/transaction.dart';
import '../repository/transaction_repository.dart';

/// Persistance locale via SharedPreferences (mode hors-ligne).
class LocalTransactionRepository implements TransactionRepository {
  @override
  bool get isRemote => false;

  Future<List<Transaction>> _readAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.prefsTransactionsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return [
        for (final e in list)
          Transaction.fromJson(e as Map<String, dynamic>),
      ];
    } catch (_) {
      return [];
    }
  }

  Future<void> _writeAll(List<Transaction> items) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(items.map((t) => t.toJson()).toList());
    await prefs.setString(AppConstants.prefsTransactionsKey, payload);
  }

  @override
  Stream<List<Transaction>> watchAll() async* {
    yield await fetchAll();
  }

  @override
  Future<List<Transaction>> fetchAll() => _readAll();

  @override
  Future<void> upsert(Transaction transaction) async {
    final items = await _readAll();
    final i = items.indexWhere((t) => t.id == transaction.id);
    if (i >= 0) {
      items[i] = transaction;
    } else {
      items.add(transaction);
    }
    await _writeAll(items);
  }

  @override
  Future<void> delete(String id) async {
    final items = await _readAll();
    items.removeWhere((t) => t.id == id);
    await _writeAll(items);
  }
}
