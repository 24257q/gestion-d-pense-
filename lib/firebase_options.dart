// Remplace ce fichier en exécutant dans le terminal :
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// Puis ajoutez `android/app/google-services.json` et `ios/Runner/GoogleService-Info.plist`
// depuis la console Firebase. Règles Firestore recommandées : voir `firestore.rules`.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Options Firebase par plateforme (valeurs factices tant que `flutterfire configure` n’a pas été lancé).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'Firebase : plateforme non prise en charge (${defaultTargetPlatform.name}). '
          'Utilisez Android, iOS, Web ou macOS, ou exécutez flutterfire configure.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDGZ16gvsbTsO5DNHu3jBThItk5-swwn7E',
    appId: '1:815200344212:web:5698808d7c690abcfc7c81',
    messagingSenderId: '815200344212',
    projectId: 'expense-manager-260cc',
    authDomain: 'expense-manager-260cc.firebaseapp.com',
    storageBucket: 'expense-manager-260cc.firebasestorage.app',
    measurementId: 'G-5G1DR2KMHG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUsqzwdfB68MzhEBHVdDIVxx36t8Cht8A',
    appId: '1:815200344212:android:eaa2ea97edf5d57bfc7c81',
    messagingSenderId: '815200344212',
    projectId: 'expense-manager-260cc',
    storageBucket: 'expense-manager-260cc.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_IOS_API_KEY',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.expense_manager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_WITH_MACOS_API_KEY',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.expense_manager',
  );
}