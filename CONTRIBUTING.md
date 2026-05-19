# Guide de contribution — Expense Manager

## Structure MVC à respecter

| Besoin | Où coder |
|--------|----------|
| Nouvelle donnée | `lib/models/` |
| Appel API / stockage | `lib/services/` |
| Règle métier, état UI | `lib/controllers/` |
| Affichage | `lib/views/` |

**Interdit** : appeler Firestore ou SharedPreferences depuis un écran.

## Ajouter une chaîne traduite

1. Déclarer le getter dans `lib/l10n/app_localizations.dart`
2. Implémenter dans `app_localizations_fr.dart` et `app_localizations_en.dart`
3. Utiliser `AppLocalizations.of(context).maCle` dans la vue

## Ajouter une catégorie

1. Ajouter la clé dans `CategoryCatalog` (`lib/models/category.dart`)
2. Ajouter les traductions dans les maps `_categories` FR et EN

## Analyse statique

```bash
flutter analyze
flutter test
```

## Formatage

Suivre les règles `flutter_lints` du projet (`analysis_options.yaml`).
