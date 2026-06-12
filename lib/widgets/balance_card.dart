import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.income,
    required this.expenses,
    required this.balance,
    required this.currencyFormat,
    required this.incomeLabel,
    required this.expensesLabel,
    required this.balanceLabel,
  });

  final double income;
  final double expenses;
  final double balance;
  final String Function(double) currencyFormat;
  final String incomeLabel;
  final String expensesLabel;
  final String balanceLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: isLight ? 0.3 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            scheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            balanceLabel.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onPrimary.withValues(alpha: 0.8),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat(balance),
            style: theme.textTheme.displayMedium?.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildSubItem(
                  context: context,
                  label: incomeLabel,
                  value: currencyFormat(income),
                  icon: Icons.arrow_downward_rounded,
                  color: const Color(0xFF10B981), // Emerald
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: scheme.onPrimary.withValues(alpha: 0.2),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSubItem(
                  context: context,
                  label: expensesLabel,
                  value: currencyFormat(expenses),
                  icon: Icons.arrow_upward_rounded,
                  color: const Color(0xFFEF4444), // Red
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubItem({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: scheme.onPrimary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: scheme.onPrimary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
