import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/load_status.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../services/transaction_service.dart';

// =============================================================================
// Module: Transaction Controller (MVC — Controller / Provider)
// Responsabilité: Logique métier CRUD, filtres, agrégations
// =============================================================================

class TransactionController extends ChangeNotifier {
  TransactionController(this._service);

  final TransactionService _service;
  StreamSubscription<List<Transaction>>? _sub;

  final List<Transaction> _items = [];
  LoadStatus _status = LoadStatus.idle;
  String? _errorMessage;
  String _searchQuery = '';
  TransactionType? _typeFilter;

  bool get cloudSyncEnabled => _service.isCloud;
  LoadStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LoadStatus.loading;
  String get searchQuery => _searchQuery;
  TransactionType? get typeFilter => _typeFilter;

  int get totalCount => _items.length;

  List<Transaction> get transactions {
    var list = List<Transaction>.from(_items)
      ..sort((a, b) => b.date.compareTo(a.date));

    if (_typeFilter != null) {
      list = list.where((t) => t.type == _typeFilter).toList();
    }

    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (t) =>
                t.title.toLowerCase().contains(q) ||
                t.categoryKey.toLowerCase().contains(q),
          )
          .toList();
    }

    return List.unmodifiable(list);
  }

  double get totalIncome => _items
      .where((t) => t.type == TransactionType.income)
      .fold<double>(0, (sum, t) => sum + t.amount);

  double get totalExpenses => _items
      .where((t) => t.type == TransactionType.expense)
      .fold<double>(0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpenses;

  /// Dépenses du mois calendaire en cours.
  double get currentMonthExpenses {
    final now = DateTime.now();
    return _items
        .where(
          (t) =>
              t.type == TransactionType.expense &&
              t.date.year == now.year &&
              t.date.month == now.month,
        )
        .fold<double>(0, (s, t) => s + t.amount);
  }

  double get savingsRate {
    final income = totalIncome;
    if (income <= 0) return 0;
    return ((income - totalExpenses) / income).clamp(0.0, 1.0);
  }

  Map<String, double> get expensesByCategoryKey {
    final map = <String, double>{};
    for (final t in _items.where((x) => x.type == TransactionType.expense)) {
      map.update(
        t.categoryKey,
        (v) => v + t.amount,
        ifAbsent: () => t.amount,
      );
    }
    return map;
  }

  String? get topExpenseCategoryKey {
    if (expensesByCategoryKey.isEmpty) return null;
    return expensesByCategoryKey.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  Future<void> initialize() async {
    await _sub?.cancel();
    _setStatus(LoadStatus.loading);

    if (_service.isCloud) {
      _sub = _service.watchTransactions(onState: _onServiceState).listen(
        (list) {
          _items
            ..clear()
            ..addAll(list);
          _setStatus(LoadStatus.success);
          notifyListeners();
        },
        onError: (Object e) {
          _setStatus(LoadStatus.error, e.toString());
          notifyListeners();
        },
      );
      return;
    }

    await refresh();
  }

  void _onServiceState(LoadStatus s, String? error) {
    _status = s;
    _errorMessage = error;
  }

  void _setStatus(LoadStatus s, [String? error]) {
    _status = s;
    _errorMessage = error;
  }

  Future<void> refresh() async {
    try {
      _setStatus(LoadStatus.loading);
      notifyListeners();
      final list = await _service.fetchTransactions(
        onState: _onServiceState,
      );
      _items
        ..clear()
        ..addAll(list);
      _setStatus(LoadStatus.success);
    } catch (e) {
      _setStatus(LoadStatus.error, e.toString());
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setTypeFilter(TransactionType? type) {
    _typeFilter = type;
    notifyListeners();
  }

  Future<void> add(Transaction transaction) async {
    try {
      await _service.add(transaction);
      if (!_service.isCloud) await refresh();
    } catch (e) {
      _setStatus(LoadStatus.error, e.toString());
      notifyListeners();
      rethrow;
    }
  }

  Future<void> update(Transaction transaction) async {
    try {
      await _service.update(transaction);
      if (!_service.isCloud) await refresh();
    } catch (e) {
      _setStatus(LoadStatus.error, e.toString());
      notifyListeners();
      rethrow;
    }
  }

  Future<void> remove(String id) async {
    try {
      await _service.remove(id);
      if (!_service.isCloud) {
        _items.removeWhere((t) => t.id == id);
        notifyListeners();
      }
    } catch (e) {
      _setStatus(LoadStatus.error, e.toString());
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    if (_status == LoadStatus.error) {
      _setStatus(LoadStatus.idle);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _service.dispose();
    super.dispose();
  }
}
