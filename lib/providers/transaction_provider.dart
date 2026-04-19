import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../services/firestore_transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  TransactionProvider({FirestoreTransactionRepository? firestore})
      : _firestore = firestore;

  static const _prefsKey = 'expense_manager_transactions_v2';

  final FirestoreTransactionRepository? _firestore;
  StreamSubscription<List<Transaction>>? _firestoreSub;

  final List<Transaction> _items = [];

  /// Vrai si les données sont synchronisées via Firestore (Firebase OK).
  bool get cloudSyncEnabled => _firestore != null;

  List<Transaction> get transactions {
    final sorted = List<Transaction>.from(_items)
      ..sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(sorted);
  }

  double get totalIncome => _items
      .where((t) => t.type == TransactionType.income)
      .fold<double>(0, (sum, t) => sum + t.amount);

  double get totalExpenses => _items
      .where((t) => t.type == TransactionType.expense)
      .fold<double>(0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpenses;

  Map<String, double> get expensesByCategory {
    final map = <String, double>{};
    for (final t in _items.where((x) => x.type == TransactionType.expense)) {
      map.update(t.category, (v) => v + t.amount, ifAbsent: () => t.amount);
    }
    return map;
  }

  /// À appeler au démarrage : écoute Firestore ou charge les préférences locales.
  Future<void> initialize() async {
    final cloud = _firestore;
    if (cloud != null) {
      await _firestoreSub?.cancel();
      _firestoreSub = cloud.watchTransactions().listen(
        (list) {
          _items
            ..clear()
            ..addAll(list);
          notifyListeners();
        },
        onError: (Object e, StackTrace st) {
          debugPrint('Firestore: $e');
        },
      );
      return;
    }
    await _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      _items.clear();
      for (final e in list) {
        _items.add(Transaction.fromJson(e as Map<String, dynamic>));
      }
      notifyListeners();
    } catch (_) {
      _items.clear();
      notifyListeners();
    }
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(_items.map((t) => t.toJson()).toList());
    await prefs.setString(_prefsKey, payload);
  }

  /// Rafraîchissement (pull-to-refresh) : relecture Firestore ou prefs.
  Future<void> load() async {
    final cloud = _firestore;
    if (cloud != null) {
      final list = await cloud.fetchOnce();
      _items
        ..clear()
        ..addAll(list);
      notifyListeners();
      return;
    }
    await _loadFromPrefs();
  }

  Future<void> add(Transaction transaction) async {
    final cloud = _firestore;
    if (cloud != null) {
      await cloud.upsert(transaction);
      return;
    }
    _items.add(transaction);
    notifyListeners();
    await _savePrefs();
  }

  Future<void> update(Transaction transaction) async {
    final cloud = _firestore;
    if (cloud != null) {
      await cloud.upsert(transaction);
      return;
    }
    final i = _items.indexWhere((t) => t.id == transaction.id);
    if (i < 0) return;
    _items[i] = transaction;
    notifyListeners();
    await _savePrefs();
  }

  Future<void> remove(String id) async {
    final cloud = _firestore;
    if (cloud != null) {
      await cloud.delete(id);
      return;
    }
    _items.removeWhere((t) => t.id == id);
    notifyListeners();
    await _savePrefs();
  }

  @override
  void dispose() {
    _firestoreSub?.cancel();
    super.dispose();
  }
}
