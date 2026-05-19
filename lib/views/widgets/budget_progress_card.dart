import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Indicateur de progression vers l’objectif budgétaire mensuel.
class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({
    super.key,
    required this.spent,
    required this.budget,
    required this.progress,
    required this.overBudget,
    required this.formattedSpent,
    required this.formattedBudget,
  });

  final double spent;
  final double budget;
  final double progress;
  final bool overBudget;
  final String formattedSpent;
  final String formattedBudget;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final pct = (progress * 100).clamp(0, 150).toStringAsFixed(0);
    final barColor = overBudget ? scheme.error : scheme.primary;

    return Material(
      color: scheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag_rounded, color: scheme.primary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.budgetProgress,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (overBudget)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.budgetExceeded,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                tween: Tween(end: progress.clamp(0.0, 1.0)),
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 10,
                    backgroundColor:
                        scheme.surfaceContainerHighest,
                    color: barColor,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$formattedSpent / $formattedBudget ($pct%)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
