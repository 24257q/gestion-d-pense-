import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';

// =============================================================================
// Module: Budget Controller (MVC — Controller / Provider)
// Responsabilité: Objectif budgétaire mensuel (fonctionnalité innovante)
// =============================================================================

class BudgetController extends ChangeNotifier {
  double _monthlyBudget = AppConstants.defaultMonthlyBudget;

  double get monthlyBudget => _monthlyBudget;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _monthlyBudget =
        prefs.getDouble(AppConstants.prefsBudgetKey) ??
            AppConstants.defaultMonthlyBudget;
    notifyListeners();
  }

  Future<void> setBudget(double value) async {
    if (value <= 0) return;
    _monthlyBudget = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.prefsBudgetKey, value);
  }

  /// Progression des dépenses du mois courant (0.0 – 1.0+).
  double progressForMonthlyExpenses(double monthExpenses) {
    if (_monthlyBudget <= 0) return 0;
    return monthExpenses / _monthlyBudget;
  }

  bool isOverBudget(double monthExpenses) =>
      monthExpenses > _monthlyBudget;
}
