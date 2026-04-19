import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/transaction.dart';

/// Persistance cloud : `users/{uid}/transactions/{transactionId}`.
class FirestoreTransactionRepository {
  FirestoreTransactionRepository();

  cf.CollectionReference<Map<String, dynamic>> get _col {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return cf.FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('transactions');
  }

  Map<String, dynamic> _encode(Transaction t) {
    final m = Map<String, dynamic>.from(t.toJson());
    m.remove('id');
    m['date'] = cf.Timestamp.fromDate(t.date);
    return m;
  }

  Transaction _decode(cf.DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = Map<String, dynamic>.from(doc.data() ?? {});
    data['id'] = doc.id;
    final rawDate = data['date'];
    if (rawDate is cf.Timestamp) {
      data['date'] = rawDate.toDate().toIso8601String();
    }
    return Transaction.fromJson(data);
  }

  Stream<List<Transaction>> watchTransactions() {
    return _col
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_decode).toList());
  }

  Future<void> upsert(Transaction t) async {
    await _col.doc(t.id).set(_encode(t));
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  Future<List<Transaction>> fetchOnce() async {
    final snap = await _col.orderBy('date', descending: true).get();
    return snap.docs.map(_decode).toList();
  }
}
