import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/transaction_controller.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/category_chart.dart';

// =============================================================================
// Module: Stats Screen (MVC — View)
// Responsabilité: Statistiques et visualisations
// =============================================================================

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final money = AppFormatters.currency(l10n.languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.stats)),
      body: Consumer<TransactionController>(
        builder: (context, tx, _) {
          final topKey = tx.topExpenseCategoryKey;
          final savingsPct = (tx.savingsRate * 100).toStringAsFixed(0);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.statsSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 20),
              _StatTile(
                icon: Icons.savings_rounded,
                label: l10n.savingsRate,
                value: '$savingsPct %',
                color: const Color(0xFF059669),
              ),
              _StatTile(
                icon: Icons.category_rounded,
                label: l10n.topExpenseCategory,
                value: topKey != null
                    ? l10n.categoryLabel(topKey)
                    : '—',
                color: const Color(0xFF6366F1),
              ),
              _StatTile(
                icon: Icons.receipt_long_rounded,
                label: l10n.transactionCount,
                value: '${tx.totalCount}',
                color: const Color(0xFF0D9488),
              ),
              _StatTile(
                icon: Icons.account_balance_wallet_rounded,
                label: l10n.balance,
                value: money.format(tx.balance),
                color: const Color(0xFF7C3AED),
              ),
              const SizedBox(height: 8),
              CategoryChart(
                dataByKey: tx.expensesByCategoryKey,
                labelForKey: l10n.categoryLabel,
                formatAmount: money.format,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            foregroundColor: color,
            child: Icon(icon),
          ),
          title: Text(label),
          trailing: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
      ),
    );
  }
}
