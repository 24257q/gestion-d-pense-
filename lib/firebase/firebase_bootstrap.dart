import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';
import '../services/firestore_transaction_repository.dart';

/// 🔐 تسجيل الدخول عبر Google
Future<void> signInWithGoogle() async {
  final googleUser = await GoogleSignIn().signIn();

  if (googleUser == null) {
    debugPrint("⚠️ User cancelled Google Sign-In");
    return;
  }

  final googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  await FirebaseAuth.instance.signInWithCredential(credential);

  debugPrint("✅ Signed in with Google");
}

/// 🚀 تهيئة Firebase + تسجيل المستخدم
Future<FirestoreTransactionRepository?> bootstrapFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint("✅ Firebase initialized");

    final auth = FirebaseAuth.instance;

    if (kIsWeb) {
      await auth.setPersistence(Persistence.LOCAL);
    }

    // 👤 تسجيل الدخول إذا لم يوجد مستخدم
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }

    debugPrint("👤 UID: ${auth.currentUser?.uid}");

    return FirestoreTransactionRepository();
  } catch (e, st) {
    debugPrint("❌ Firebase ERROR: $e");
    debugPrint("$st");
    return null;
  }
}