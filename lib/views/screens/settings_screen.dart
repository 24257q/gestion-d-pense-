import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/budget_controller.dart';
import '../../controllers/locale_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../l10n/app_localizations.dart';

// =============================================================================
// Module: Settings Screen (MVC — View)
// Responsabilité: Langue, thème, budget mensuel
// =============================================================================

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final budget = context.read<BudgetController>().monthlyBudget;
    _budgetController.text = budget.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = context.watch<LocaleController>();
    final themeCtrl = context.watch<ThemeController>();
    final budget = context.watch<BudgetController>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.language,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'fr', label: Text(l10n.languageFr)),
              ButtonSegment(value: 'en', label: Text(l10n.languageEn)),
            ],
            selected: {locale.locale.languageCode},
            onSelectionChanged: (s) {
              if (s.isNotEmpty) {
                locale.setLocale(Locale(s.first));
              }
            },
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: Text(
              themeCtrl.isDark ? l10n.darkMode : l10n.lightMode,
            ),
            secondary: Icon(
              themeCtrl.isDark
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
            ),
            value: themeCtrl.isDark,
            onChanged: (v) => themeCtrl.setDark(v),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.monthlyBudget,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.budgetHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _budgetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: l10n.budgetHint),
            onSubmitted: (v) {
              final n = double.tryParse(v.replaceAll(',', '.'));
              if (n != null) budget.setBudget(n);
            },
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              final n = double.tryParse(
                _budgetController.text.replaceAll(',', '.'),
              );
              if (n != null && n > 0) {
                budget.setBudget(n);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.saveTransaction)),
                );
              }
            },
            icon: const Icon(Icons.save_rounded),
            label: Text(l10n.saveTransaction),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.about,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.aboutText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                ),
          ),
        ],
      ),
    );
  }
}
