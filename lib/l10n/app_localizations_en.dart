import '../models/category.dart';
import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  @override
  String get languageCode => 'en';

  @override
  String get appTitle => 'Expense Manager';

  @override
  String get income => 'Income';
  @override
  String get expenses => 'Expenses';
  @override
  String get balance => 'Balance';
  @override
  String get transactions => 'Transactions';
  @override
  String get emptyTransactions =>
      'No transactions yet.\nTap + to add income or an expense.';
  @override
  String get add => 'Add';
  @override
  String get expensesByCategory => 'Expenses by category';
  @override
  String get chartPlaceholder => 'Add expenses to see the chart.';
  @override
  String get addTransaction => 'New transaction';
  @override
  String get editTransaction => 'Edit transaction';
  @override
  String get updateTransaction => 'Update';
  @override
  String get editScreenSubtitle => 'Edit the fields and save.';
  @override
  String get addScreenSubtitle => 'Fill in the form below';
  @override
  String get editTooltip => 'Edit';
  @override
  String get deleteTooltip => 'Delete';
  @override
  String get incomeType => 'Income';
  @override
  String get expenseType => 'Expense';
  @override
  String get titleOptional => 'Title (optional)';
  @override
  String get titleHint => 'e.g. Weekly groceries';
  @override
  String get amount => 'Amount';
  @override
  String get amountHint => '0.00';
  @override
  String get category => 'Category';
  @override
  String get date => 'Date';
  @override
  String get saveTransaction => 'Save';
  @override
  String get enterAmount => 'Enter an amount';
  @override
  String get enterValidAmount => 'Invalid amount (must be > 0)';
  @override
  String get detailsSection => 'Details';
  @override
  String get pickDateTooltip => 'Pick date';
  @override
  String get cloudSyncOn => 'Synced with cloud (Firebase)';
  @override
  String get cloudSyncOff => 'Local mode — Firebase unavailable';
  @override
  String get loading => 'Loading…';
  @override
  String get errorGeneric => 'Something went wrong';
  @override
  String get retry => 'Retry';
  @override
  String get settings => 'Settings';
  @override
  String get language => 'Language';
  @override
  String get languageFr => 'Français';
  @override
  String get languageEn => 'English';
  @override
  String get monthlyBudget => 'Monthly budget';
  @override
  String get budgetHint => 'Monthly spending goal';
  @override
  String get budgetProgress => 'Budget progress';
  @override
  String get budgetExceeded => 'Budget exceeded!';
  @override
  String get searchHint => 'Search transactions…';
  @override
  String get noSearchResults => 'No results for this search';
  @override
  String get stats => 'Statistics';
  @override
  String get statsSubtitle => 'Overview of your finances this month';
  @override
  String get savingsRate => 'Savings rate';
  @override
  String get topExpenseCategory => 'Top expense category';
  @override
  String get transactionCount => 'Transaction count';
  @override
  String get home => 'Home';
  @override
  String get about => 'About';
  @override
  String get aboutText =>
      'Academic expense tracker — Flutter, Provider, MVC, Firebase.';
  @override
  String get filterAll => 'All';
  @override
  String get filterIncome => 'Income';
  @override
  String get filterExpense => 'Expenses';
  @override
  String get confirmDelete => 'Delete this transaction?';
  @override
  String get cancel => 'Cancel';
  @override
  String get delete => 'Delete';
  @override
  String get darkMode => 'Dark mode';
  @override
  String get lightMode => 'Light mode';

  static const _categories = <String, String>{
    'food': 'Food',
    'transport': 'Transport',
    'bills': 'Bills',
    'shopping': 'Shopping',
    'entertainment': 'Entertainment',
    'health': 'Health',
    'other': 'Other',
    'salary': 'Salary',
    'freelance': 'Freelance',
    'investment': 'Investment',
    'gift': 'Gift',
    'other_income': 'Other income',
  };

  @override
  String categoryLabel(String key) {
    final normalized = CategoryCatalog.normalizeKey(key);
    return _categories[normalized] ?? key;
  }
}
