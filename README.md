# Expense Manager — Gestionnaire de dépenses

Application mobile **Flutter** pour le suivi des revenus et dépenses, conçue pour un projet académique de **Développement Mobile**.

## Fonctionnalités

- Tableau de bord (revenus, dépenses, solde)
- **CRUD** complet des transactions (ajout, modification, suppression)
- Formulaires avec **validation**
- Navigation multi-écrans (accueil, statistiques, paramètres)
- Graphique des dépenses par catégorie (`fl_chart`)
- **Budget mensuel** avec barre de progression
- Recherche et filtres (revenus / dépenses)
- **Synchronisation cloud** Firebase Firestore (repli local SharedPreferences)
- **Internationalisation** FR / EN (changement dans l’app)
- Mode clair / sombre
- Animations de transition entre écrans

## Technologies

| Couche | Technologie |
|--------|-------------|
| UI | Flutter (Material 3) |
| État | **Provider** (Controllers) |
| Architecture | **MVC** |
| Données locales | SharedPreferences |
| API / Cloud | Firebase Auth + Cloud Firestore |
| Graphiques | fl_chart |
| i18n | Délégation personnalisée FR/EN |

## Structure du projet (MVC)

```
lib/
├── main.dart                 # Bootstrap & MultiProvider
├── app.dart                  # MaterialApp
├── models/                   # Model — entités & enums
├── views/                    # View — écrans & widgets réutilisables
├── controllers/              # Controller — ChangeNotifier (Provider)
├── services/                 # Persistance & API
│   ├── repository/
│   ├── local/
│   └── api/
├── core/                     # Thème, navigation, utilitaires
├── l10n/                     # Traductions FR / EN
└── firebase/                 # Initialisation Firebase
```

Documentation détaillée :

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [docs/PRESENTATION.md](docs/PRESENTATION.md)
- [docs/TEAM.md](docs/TEAM.md)
- [CONTRIBUTING.md](CONTRIBUTING.md)

## Démarrage

```bash
flutter pub get
flutter run
```

### Firebase (optionnel)

1. Créer un projet Firebase et activer **Authentication** (anonyme) et **Firestore**.
2. Configurer les plateformes avec `flutterfire configure`.
3. Sans Firebase, l’app fonctionne en **mode local**.

## Équipe & collaboration

Voir [docs/TEAM.md](docs/TEAM.md) pour la répartition des modules et [CONTRIBUTING.md](CONTRIBUTING.md) pour les conventions de code.

## Licence

Projet académique — usage pédagogique.
