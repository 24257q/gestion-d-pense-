
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'l10n/app_strings.dart';
import 'firebase/firebase_bootstrap.dart';
import 'l10n/app_ar.dart';
import 'providers/transaction_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');
  await initializeDateFormatting('fr');

  final cloud = await bootstrapFirebase();
  final transactions = TransactionProvider(firestore: cloud);

  print("========== DEBUG ==========");
  print("Firebase connected? ${cloud != null}");
  print("===========================");

  await transactions.initialize();

  runApp(
    ChangeNotifierProvider<TransactionProvider>.value(
      value: transactions,
      child: const ExpenseManagerApp(),
    ),
  );
}

class ExpenseManagerApp extends StatefulWidget {
  const ExpenseManagerApp({super.key});

  static _ExpenseManagerAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ExpenseManagerAppState>();
  }

  @override
  State<ExpenseManagerApp> createState() => _ExpenseManagerAppState();
}

class _ExpenseManagerAppState extends State<ExpenseManagerApp> {
  String currentLang = 'ar';

  void changeLang(String lang) {
    setState(() {
      currentLang = lang;
      AppStrings.currentLang = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppAr.appTitle,
      debugShowCheckedModeBanner: false,

      locale: Locale(currentLang),

      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('fr'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: AppTheme.light(),
      home: const HomeScreen(),
    );
  }
}