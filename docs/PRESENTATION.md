# Guide de présentation — Expense Manager

Document pour la **soutenance universitaire** (démonstration orale).

---

## 1. Introduction (1 min)

- **Problème** : difficile de suivre ses dépenses au quotidien sans outil simple.
- **Solution** : application mobile de gestion des revenus et dépenses avec visualisation et budget mensuel.

---

## 2. Architecture (2 min)

- Pattern **MVC** adapté à Flutter :
  - **Model** : `Transaction`, catégories, statuts de chargement
  - **View** : écrans dans `lib/views/`
  - **Controller** : `ChangeNotifier` exposés via **Provider**
- Couche **Services** pour l’API / base de données (contrat `TransactionRepository`).
- Schéma : voir [ARCHITECTURE.md](ARCHITECTURE.md).

---

## 3. Fonctionnalités démontrées (5 min)

| Fonctionnalité | Comment montrer |
|----------------|-----------------|
| CRUD | Ajouter → modifier → glisser pour supprimer |
| Validation | Soumettre formulaire vide / montant invalide |
| Navigation | Onglets Accueil / Statistiques / Paramètres |
| Graphique | Ajouter plusieurs dépenses par catégorie |
| Budget | Paramètres → budget → barre sur l’accueil |
| Recherche / filtre | Barre de recherche + segments revenus/dépenses |
| i18n | Paramètres → FR ↔ EN |
| Thème | Mode sombre dans paramètres |
| Cloud | Bannière verte si Firebase actif |

---

## 4. Technologies (1 min)

- **Flutter** + **Dart 3**
- **Provider** (gestion d’état)
- **Firebase** (Auth anonyme + Firestore) ou **SharedPreferences** hors-ligne
- **fl_chart** pour les graphiques
- **intl** pour dates et devises

---

## 5. Répartition des tâches (équipe)

| Membre | Module | Livrables |
|--------|--------|-----------|
| A | Models + Services | Entités, repositories, `TransactionService` |
| B | Controllers | CRUD, agrégations, budget, locale |
| C | Views — Accueil & formulaire | `HomeScreen`, `AddTransactionScreen`, widgets |
| D | Views — Stats & paramètres | `StatsScreen`, `SettingsScreen`, i18n |
| E | Firebase & doc | Bootstrap, README, présentation |

*(Adapter les noms dans [TEAM.md](TEAM.md).)*

---

## 6. Difficultés rencontrées

| Difficulté | Solution |
|------------|----------|
| Synchronisation temps réel Firestore | `Stream` + `watchAll()` dans le repository |
| Mode hors-ligne | Repository local interchangeable au démarrage |
| Catégories multilingues | Clés stables + traduction dans `AppLocalizations` |
| État de chargement dispersé | Centralisation dans `TransactionService` + `LoadStatus` |

---

## 7. Originalité

- Objectif **budget mensuel** avec alerte visuelle
- **Taux d’épargne** et catégorie principale sur l’écran statistiques
- UI Material 3 (cartes, dégradés, animations de page)
- Bascule FR/EN et thème sombre sans redémarrer l’app

---

## 8. Conclusion (1 min)

- Application complète, maintenable, prête pour évaluation.
- Pistes d’évolution : export PDF, connexion Google, catégories personnalisées.

---

## Checklist avant la démo

- [ ] `flutter pub get` exécuté
- [ ] Données de test (3–5 transactions variées)
- [ ] Firebase configuré OU mode local testé
- [ ] Langue FR et EN testées
- [ ] Émulateur / appareil chargé à 100 %
