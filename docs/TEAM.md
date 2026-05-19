# Répartition des tâches — Travail collaboratif

## Organisation du dépôt

Chaque **module** correspond à un dossier `lib/` documenté en en-tête de fichier :

```
// Module: … (MVC — …)
// Responsabilité: …
```

## Matrice des responsabilités

| Module | Dossier | Tâches | Statut |
|--------|---------|--------|--------|
| Modèles | `lib/models/` | `Transaction`, catégories, `LoadStatus` | ✅ |
| Services | `lib/services/` | Repository, local, Firestore, orchestration | ✅ |
| Controllers | `lib/controllers/` | Provider, CRUD, budget, locale, thème | ✅ |
| Vues | `lib/views/` | Écrans, widgets réutilisables | ✅ |
| i18n | `lib/l10n/` | FR, EN, délégué | ✅ |
| Core | `lib/core/` | Thème, navigation, formatters | ✅ |
| Firebase | `lib/firebase/` | Bootstrap, auth | ✅ |
| Documentation | `docs/`, `README.md` | Architecture, présentation | ✅ |

## Convention Git (recommandée)

- `feature/nom-module` — nouvelle fonctionnalité
- `fix/description` — correction de bug
- Commits en français ou anglais, message impératif : *« Ajoute filtre par type de transaction »*

## Revue de code entre pairs

1. Ouvrir une PR vers `main`
2. Vérifier : pas de logique métier dans les `views/`
3. Vérifier : pas d’appel Firestore direct depuis les controllers (passer par `TransactionService`)
4. Lancer `flutter analyze` avant merge

## Communication

- **Daily** : 10 min — blocages API / UI
- **Documentation** : mettre à jour `TEAM.md` si la répartition change

## Noms de l’équipe (à compléter)

| Rôle | Nom | Contact |
|------|-----|---------|
| Chef de projet | _À compléter_ | |
| Dev backend / Firebase | _À compléter_ | |
| Dev UI | _À compléter_ | |
| Dev état / logique | _À compléter_ | |
| QA / démo | _À compléter_ | |
