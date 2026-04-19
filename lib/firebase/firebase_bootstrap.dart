import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';
import '../services/firestore_transaction_repository.dart';

/// Initialise Firebase + connexion anonyme. Retourne `null` si échec (app en mode local).
Future<FirestoreTransactionRepository?> bootstrapFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }
    if (auth.currentUser == null) {
      debugPrint('Firebase Auth: aucun utilisateur après signInAnonymously');
      return null;
    }
    return FirestoreTransactionRepository();
  } catch (e, st) {
    debugPrint('Firebase indisponible — mode local uniquement. $e');
    debugPrint('$st');
    return null;
  }
}
