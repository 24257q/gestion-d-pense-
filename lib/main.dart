import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'controllers/budget_controller.dart';
import 'controllers/locale_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/transaction_controller.dart';
import 'firebase/firebase_bootstrap.dart';
import 'services/local/local_transaction_repository.dart';
import 'services/transaction_service.dart';

// =============================================================================
// Point d’entrée — composition Provider (Controllers) + bootstrap données
// =============================================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr');
  await initializeDateFormatting('en');

  final remoteRepo = await bootstrapFirebase();
  final repository =
      remoteRepo ?? LocalTransactionRepository();
  final service = TransactionService(repository);

  final localeController = LocaleController();
  final themeController = ThemeController();
  final budgetController = BudgetController();
  final transactionController = TransactionController(service);

  await localeController.load();
  await budgetController.load();
  await transactionController.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleController>.value(
          value: localeController,
        ),
        ChangeNotifierProvider<ThemeController>.value(value: themeController),
        ChangeNotifierProvider<BudgetController>.value(
          value: budgetController,
        ),
        ChangeNotifierProvider<TransactionController>.value(
          value: transactionController,
        ),
      ],
      child: const ExpenseManagerApp(),
    ),
  );
}
