import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/load_status.dart';
import '../models/transaction.dart';
import 'repository/transaction_repository.dart';

// =============================================================================
// Module: Transaction Service
// Responsabilité: Orchestration API — chargement, erreurs, flux temps réel
// =============================================================================

class TransactionService {
  TransactionService(this._repository);

  final TransactionRepository _repository;
  StreamSubscription<List<Transaction>>? _subscription;

  bool get isCloud => _repository.isRemote;

  LoadStatus status = LoadStatus.idle;
  String? lastError;

  void _setStatus(LoadStatus s, {String? error}) {
    status = s;
    lastError = error;
  }

  /// Écoute le dépôt (Firestore) ou charge une fois (local).
  Stream<List<Transaction>> watchTransactions({
    void Function(LoadStatus status, String? error)? onState,
  }) {
    if (_repository.isRemote) {
      return _repository.watchAll().map((list) {
        _setStatus(LoadStatus.success);
        onState?.call(LoadStatus.success, null);
        return list;
      }).handleError((Object e) {
        _setStatus(LoadStatus.error, error: e.toString());
        onState?.call(LoadStatus.error, e.toString());
      });
    }

    return Stream.fromFuture(fetchTransactions(onState: onState));
  }

  Future<List<Transaction>> fetchTransactions({
    void Function(LoadStatus status, String? error)? onState,
  }) async {
    try {
      _setStatus(LoadStatus.loading);
      onState?.call(LoadStatus.loading, null);
      final list = await _repository.fetchAll();
      _setStatus(LoadStatus.success);
      onState?.call(LoadStatus.success, null);
      return list;
    } catch (e, st) {
      debugPrint('TransactionService.fetch: $e\n$st');
      _setStatus(LoadStatus.error, error: e.toString());
      onState?.call(LoadStatus.error, e.toString());
      rethrow;
    }
  }

  Future<void> add(Transaction t) async {
    try {
      _setStatus(LoadStatus.loading);
      await _repository.upsert(t);
      _setStatus(LoadStatus.success);
    } catch (e, st) {
      debugPrint('TransactionService.add: $e\n$st');
      _setStatus(LoadStatus.error, error: e.toString());
      rethrow;
    }
  }

  Future<void> update(Transaction t) async {
    try {
      _setStatus(LoadStatus.loading);
      await _repository.upsert(t);
      _setStatus(LoadStatus.success);
    } catch (e, st) {
      debugPrint('TransactionService.update: $e\n$st');
      _setStatus(LoadStatus.error, error: e.toString());
      rethrow;
    }
  }

  Future<void> remove(String id) async {
    try {
      _setStatus(LoadStatus.loading);
      await _repository.delete(id);
      _setStatus(LoadStatus.success);
    } catch (e, st) {
      debugPrint('TransactionService.remove: $e\n$st');
      _setStatus(LoadStatus.error, error: e.toString());
      rethrow;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
