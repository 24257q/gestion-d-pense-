import '../../models/transaction.dart';

// =============================================================================
// Module: Transaction Repository (contrat de persistance)
// Responsabilité: Abstraction données locales / cloud (API)
// =============================================================================

/// Contrat pour la couche données — implémentations locale et Firestore.
abstract class TransactionRepository {
  bool get isRemote;

  Stream<List<Transaction>> watchAll();

  Future<List<Transaction>> fetchAll();

  Future<void> upsert(Transaction transaction);

  Future<void> delete(String id);
}
