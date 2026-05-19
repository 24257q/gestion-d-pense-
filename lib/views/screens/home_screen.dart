import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/budget_controller.dart';
import '../../controllers/transaction_controller.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../models/load_status.dart';
import '../../models/transaction.dart';
import '../../models/transaction_type.dart';
import '../widgets/budget_progress_card.dart';
import '../widgets/category_chart.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_banner.dart';
import '../widgets/page_transitions.dart';
import '../widgets/summary_card.dart';
import '../widgets/sync_banner.dart';
import 'add_transaction_screen.dart';

// =============================================================================
// Module: Home Screen (MVC — View)
// Responsabilité: Tableau de bord — liste, recherche, CRUD
// =============================================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.languageCode;
    final money = AppFormatters.currency(locale);
    final dateFmt = AppFormatters.shortDate(locale);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.92),
                Theme.of(context).colorScheme.surface.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
      body: Consumer2<TransactionController, BudgetController>(
        builder: (context, tx, budget, _) {
          final scheme = Theme.of(context).colorScheme;
          final list = tx.transactions;
          final monthExpenses = tx.currentMonthExpenses;
          final progress = budget.progressForMonthlyExpenses(monthExpenses);

          return Stack(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      scheme.primary.withValues(alpha: 0.07),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: RefreshIndicator(
                  color: scheme.primary,
                  onRefresh: tx.refresh,
                  edgeOffset:
                      kToolbarHeight + MediaQuery.paddingOf(context).top,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          MediaQuery.paddingOf(context).top +
                              kToolbarHeight +
                              8,
                          16,
                          8,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SyncBanner(cloudEnabled: tx.cloudSyncEnabled),
                              if (tx.status == LoadStatus.error &&
                                  tx.errorMessage != null) ...[
                                const SizedBox(height: 10),
                                ErrorBanner(
                                  message: tx.errorMessage!,
                                  onRetry: tx.refresh,
                                ),
                              ],
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: SummaryCard(
                                      label: l10n.income,
                                      value: money.format(tx.totalIncome),
                                      accent: const Color(0xFF059669),
                                      icon: Icons.trending_up_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SummaryCard(
                                      label: l10n.expenses,
                                      value: money.format(tx.totalExpenses),
                                      accent: const Color(0xFFDC2626),
                                      icon: Icons.trending_down_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SummaryCard(
                                      label: l10n.balance,
                                      value: money.format(tx.balance),
                                      accent: const Color(0xFF7C3AED),
                                      icon: Icons
                                          .account_balance_wallet_rounded,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              BudgetProgressCard(
                                spent: monthExpenses,
                                budget: budget.monthlyBudget,
                                progress: progress,
                                overBudget:
                                    budget.isOverBudget(monthExpenses),
                                formattedSpent: money.format(monthExpenses),
                                formattedBudget:
                                    money.format(budget.monthlyBudget),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: CategoryChart(
                          dataByKey: tx.expensesByCategoryKey,
                          labelForKey: l10n.categoryLabel,
                          formatAmount: money.format,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: l10n.searchHint,
                              prefixIcon: const Icon(Icons.search_rounded),
                              suffixIcon: tx.searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded),
                                      onPressed: () =>
                                          tx.setSearchQuery(''),
                                    )
                                  : null,
                            ),
                            onChanged: tx.setSearchQuery,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SegmentedButton<TransactionType?>(
                            showSelectedIcon: false,
                            emptySelectionAllowed: true,
                            segments: [
                              ButtonSegment(
                                value: null,
                                label: Text(l10n.filterAll),
                              ),
                              ButtonSegment(
                                value: TransactionType.income,
                                label: Text(l10n.filterIncome),
                              ),
                              ButtonSegment(
                                value: TransactionType.expense,
                                label: Text(l10n.filterExpense),
                              ),
                            ],
                            selected: {tx.typeFilter},
                            onSelectionChanged: (s) {
                              tx.setTypeFilter(s.isEmpty ? null : s.first);
                            },
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.receipt_long_rounded,
                                size: 22,
                                color: scheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.transactions,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              if (list.isNotEmpty)
                                Material(
                                  color: scheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      '${list.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: scheme.onPrimaryContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (list.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyState(
                            message: tx.searchQuery.isNotEmpty
                                ? l10n.noSearchResults
                                : l10n.emptyTransactions,
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _TransactionTile(
                                transaction: list[index],
                                money: money,
                                dateFmt: dateFmt,
                                categoryLabel: l10n.categoryLabel(
                                  list[index].categoryKey,
                                ),
                              ),
                              childCount: list.length,
                            ),
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 96)),
                    ],
                  ),
                ),
              ),
              if (tx.isLoading)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(minHeight: 3),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            AppPageTransitions.fadeSlide(const AddTransactionScreen()),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.add),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.transaction,
    required this.money,
    required this.dateFmt,
    required this.categoryLabel,
  });

  final Transaction transaction;
  final NumberFormat money;
  final DateFormat dateFmt;
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tx = context.read<TransactionController>();
    final isIncome = transaction.type == TransactionType.income;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: ValueKey(transaction.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsetsDirectional.only(end: 20),
          decoration: BoxDecoration(
            color: scheme.error,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(Icons.delete_outline_rounded, color: scheme.onError),
        ),
        confirmDismiss: (_) async {
          return await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.confirmDelete),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n.cancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.delete),
                    ),
                  ],
                ),
              ) ??
              false;
        },
        onDismissed: (_) => tx.remove(transaction.id),
        child: Material(
          color: scheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isIncome
                  ? const Color(0xFFD1FAE5)
                  : const Color(0xFFFEE2E2),
              foregroundColor: isIncome
                  ? const Color(0xFF047857)
                  : const Color(0xFFB91C1C),
              child: Icon(
                isIncome
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                size: 22,
              ),
            ),
            title: Text(
              transaction.displayTitle(categoryLabel),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '$categoryLabel · ${dateFmt.format(transaction.date)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.filledTonal(
                  visualDensity: VisualDensity.compact,
                  tooltip: l10n.editTooltip,
                  onPressed: () {
                    Navigator.of(context).push(
                      AppPageTransitions.fadeSlide(
                        AddTransactionScreen(initial: transaction),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_rounded, size: 20),
                ),
                const SizedBox(width: 4),
                Text(
                  '${isIncome ? '+' : '-'}${money.format(transaction.amount)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isIncome
                        ? const Color(0xFF059669)
                        : scheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
