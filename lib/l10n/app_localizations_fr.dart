import '../models/category.dart';
import 'app_localizations.dart';

class AppLocalizationsFr extends AppLocalizations {
  @override
  String get languageCode => 'fr';

  @override
  String get appTitle => 'Gestionnaire de dépenses';

  @override
  String get income => 'Revenus';
  @override
  String get expenses => 'Dépenses';
  @override
  String get balance => 'Solde';
  @override
  String get transactions => 'Transactions';
  @override
  String get emptyTransactions =>
      'Aucune transaction.\nAppuyez sur + pour ajouter un revenu ou une dépense.';
  @override
  String get add => 'Ajouter';
  @override
  String get expensesByCategory => 'Dépenses par catégorie';
  @override
  String get chartPlaceholder =>
      'Ajoutez des dépenses pour afficher le graphique.';
  @override
  String get addTransaction => 'Nouvelle transaction';
  @override
  String get editTransaction => 'Modifier la transaction';
  @override
  String get updateTransaction => 'Mettre à jour';
  @override
  String get editScreenSubtitle =>
      'Modifiez les champs puis enregistrez.';
  @override
  String get addScreenSubtitle => 'Remplissez le formulaire ci-dessous';
  @override
  String get editTooltip => 'Modifier';
  @override
  String get deleteTooltip => 'Supprimer';
  @override
  String get incomeType => 'Revenu';
  @override
  String get expenseType => 'Dépense';
  @override
  String get titleOptional => 'Titre (optionnel)';
  @override
  String get titleHint => 'Ex. Courses de la semaine';
  @override
  String get amount => 'Montant';
  @override
  String get amountHint => '0,00';
  @override
  String get category => 'Catégorie';
  @override
  String get date => 'Date';
  @override
  String get saveTransaction => 'Enregistrer';
  @override
  String get enterAmount => 'Saisissez un montant';
  @override
  String get enterValidAmount => 'Montant invalide (doit être > 0)';
  @override
  String get detailsSection => 'Détails';
  @override
  String get pickDateTooltip => 'Choisir la date';
  @override
  String get cloudSyncOn => 'Synchronisé avec le cloud (Firebase)';
  @override
  String get cloudSyncOff =>
      'Mode local — Firebase non configuré ou indisponible';
  @override
  String get loading => 'Chargement…';
  @override
  String get errorGeneric => 'Une erreur est survenue';
  @override
  String get retry => 'Réessayer';
  @override
  String get settings => 'Paramètres';
  @override
  String get language => 'Langue';
  @override
  String get languageFr => 'Français';
  @override
  String get languageEn => 'English';
  @override
  String get monthlyBudget => 'Budget mensuel';
  @override
  String get budgetHint => 'Objectif de dépenses du mois';
  @override
  String get budgetProgress => 'Progression du budget';
  @override
  String get budgetExceeded => 'Budget dépassé !';
  @override
  String get searchHint => 'Rechercher une transaction…';
  @override
  String get noSearchResults => 'Aucun résultat pour cette recherche';
  @override
  String get stats => 'Statistiques';
  @override
  String get statsSubtitle => 'Aperçu de vos finances ce mois-ci';
  @override
  String get savingsRate => 'Taux d’épargne';
  @override
  String get topExpenseCategory => 'Catégorie principale';
  @override
  String get transactionCount => 'Nombre de transactions';
  @override
  String get home => 'Accueil';
  @override
  String get about => 'À propos';
  @override
  String get aboutText =>
      'Application académique de gestion des dépenses — Flutter, Provider, MVC, Firebase.';
  @override
  String get filterAll => 'Tout';
  @override
  String get filterIncome => 'Revenus';
  @override
  String get filterExpense => 'Dépenses';
  @override
  String get confirmDelete => 'Supprimer cette transaction ?';
  @override
  String get cancel => 'Annuler';
  @override
  String get delete => 'Supprimer';
  @override
  String get darkMode => 'Mode sombre';
  @override
  String get lightMode => 'Mode clair';

  static const _categories = <String, String>{
    'food': 'Alimentation',
    'transport': 'Transport',
    'bills': 'Factures',
    'shopping': 'Shopping',
    'entertainment': 'Loisirs',
    'health': 'Santé',
    'other': 'Autre',
    'salary': 'Salaire',
    'freelance': 'Freelance',
    'investment': 'Investissement',
    'gift': 'Cadeau',
    'other_income': 'Autre revenu',
  };

  @override
  String categoryLabel(String key) {
    final normalized = CategoryCatalog.normalizeKey(key);
    return _categories[normalized] ?? key;
  }
}
