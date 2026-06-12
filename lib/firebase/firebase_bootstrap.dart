import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';
import '../services/api/firestore_transaction_repository.dart';
import '../services/repository/transaction_repository.dart';

// =============================================================================
// Module: Firebase Bootstrap
// Responsabilité: Initialisation Firebase + auth anonyme
// =============================================================================

Future<TransactionRepository?> bootstrapFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final auth = FirebaseAuth.instance;

    if (kIsWeb) {
      await auth.setPersistence(Persistence.LOCAL);
    }

    debugPrint('Firebase OK — uid: ${auth.currentUser?.uid}');
    return FirestoreTransactionRepository();
  } catch (e, st) {
    debugPrint('Firebase unavailable: $e\n$st');
    return null;
  }
}
