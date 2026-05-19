import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_ar.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../providers/transaction_provider.dart';
import '../widgets/chart_widget.dart';
import 'add_transaction_screen.dart';
import '../l10n/app_strings.dart';
import '../main.dart';

Future<void> _pushTransactionForm(
  BuildContext context, {
  Transaction? initial,
}) {
  return Navigator.of(context).push<void>(
    PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AddTransactionScreen(initial: initial),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  String _currencySymbol() {
    switch (AppStrings.currentLang) {
      case 'en':
        return r'$';
      case 'fr':
        return '€';
      default:
        return r'$'; // أو عملتك المحلية
    }
  }

  NumberFormat get _money => NumberFormat.currency(
    locale: AppStrings.currentLang,
    decimalDigits: 2,
    symbol: _currencySymbol(),
  );
  DateFormat get _date => DateFormat.MMMd(AppStrings.currentLang);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(AppStrings.appTitle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (lang) {
              ExpenseManagerApp.of(context)?.changeLang(lang);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'ar', child: Text('العربية')),
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'fr', child: Text('Français')),
            ],
          ),
        ],

        flexibleSpace: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                scheme.surface.withValues(alpha: 0.92),
                scheme.surface.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          final income = provider.totalIncome;
          final expenses = provider.totalExpenses;
          final balance = provider.balance;
          final list = provider.transactions;

          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  scheme.primary.withValues(alpha: 0.07),
                  theme.scaffoldBackgroundColor,
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
            child: RefreshIndicator(
              color: scheme.primary,
              onRefresh: () => provider.load(),
              edgeOffset: kToolbarHeight + MediaQuery.paddingOf(context).top,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      MediaQuery.paddingOf(context).top + kToolbarHeight + 8,
                      16,
                      8,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SyncBanner(cloudEnabled: provider.cloudSyncEnabled),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _SummaryCard(
                                  label: AppStrings.income,
                                  value: _money.format(income),
                                  accent: const Color(0xFF059669),
                                  icon: Icons.trending_up_rounded,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _SummaryCard(
                                  label: AppStrings.expenses,
                                  value: _money.format(expenses),
                                  accent: const Color(0xFFDC2626),
                                  icon: Icons.trending_down_rounded,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _SummaryCard(
                                  label: AppStrings.balance,
                                  value: _money.format(balance),
                                  accent: const Color(0xFF7C3AED),
                                  icon: Icons.account_balance_wallet_rounded,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ExpenseCategoryChart(
                      data: provider.expensesByCategory,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
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
                              AppStrings.transactions,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
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
                                  style: theme.textTheme.labelLarge?.copyWith(
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
                      child: _EmptyState(message: AppStrings.emptyTransactions),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final t = list[index];
                            final isIncome = t.type == TransactionType.income;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Dismissible(
                                key: ValueKey(t.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: AlignmentDirectional.centerEnd,
                                  padding:
                                      const EdgeInsetsDirectional.only(end: 20),
                                  decoration: BoxDecoration(
                                    color: scheme.error,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    color: scheme.onError,
                                    size: 28,
                                  ),
                                ),
                                onDismissed: (_) => provider.remove(t.id),
                                child: Material(
                                  color: scheme.surfaceContainerLowest,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: BorderSide(
                                      color: scheme.outlineVariant
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 22,
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
                                      t.displayTitle,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        '${AppStrings.categoryName(t.category)} · ${_date.format(t.date)}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton.filledTonal(
                                          visualDensity: VisualDensity.compact,
                                          tooltip: AppStrings.editTooltip,
                                          onPressed: () =>
                                              _pushTransactionForm(
                                            context,
                                            initial: t,
                                          ),
                                          icon: const Icon(
                                            Icons.edit_rounded,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${isIncome ? '+' : '-'}${_money.format(t.amount)}',
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
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
                          },
                          childCount: list.length,
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 96)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 3,
        onPressed: () => _pushTransactionForm(context),
        icon: const Icon(Icons.add_rounded),
        label:  Text(AppStrings.add),
      ),
    );
  }
}

class _SyncBanner extends StatelessWidget {
  const _SyncBanner({required this.cloudEnabled});

  final bool cloudEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      borderRadius: BorderRadius.circular(14),
      color: cloudEnabled
          ? const Color(0xFFD1FAE5).withValues(alpha: 0.92)
          : scheme.surfaceContainerHighest.withValues(alpha: 0.9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              cloudEnabled ? Icons.cloud_done_rounded : Icons.cloud_off_outlined,
              size: 22,
              color: cloudEnabled
                  ? const Color(0xFF047857)
                  : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                cloudEnabled ? AppStrings.cloudSyncOn : AppStrings.cloudSyncOff,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cloudEnabled
                      ? const Color(0xFF065F46)
                      : scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.accent,
    required this.icon,
  });

  final String label;
  final String value;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.14),
            accent.withValues(alpha: 0.06),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: accent),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primaryContainer.withValues(alpha: 0.45),
              ),
              child: Icon(
                Icons.savings_outlined,
                size: 48,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
