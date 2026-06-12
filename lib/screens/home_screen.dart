import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_ar.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';
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
      body: Consumer<TransactionController>(
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
              onRefresh: () => provider.refresh(),
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
                          BalanceCard(
                            income: income,
                            expenses: expenses,
                            balance: balance,
                            currencyFormat: _money.format,
                            incomeLabel: AppStrings.income,
                            expensesLabel: AppStrings.expenses,
                            balanceLabel: AppStrings.balance,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: DashboardCharts(
                      pieData: provider.expensesByCategoryKey,
                      weeklyData: provider.weeklyExpenses,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                      child: Column(
                        children: [
                          Row(
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
                              const SizedBox(width: 8),
                              IconButton.filledTonal(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
                                onPressed: list.isEmpty ? null : () => provider.exportToPdf(),
                                tooltip: AppStrings.currentLang == 'fr' ? 'Exporter PDF' : 'Export PDF',
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: provider.setSearchQuery,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.currentLang == 'fr' ? 'Rechercher...' : 'Search...',
                                    prefixIcon: const Icon(Icons.search_rounded),
                                    filled: true,
                                    fillColor: scheme.surface,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: scheme.outlineVariant.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: scheme.primary,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              IconButton.filledTonal(
                                icon: Icon(
                                  provider.startDate != null ? Icons.event_available_rounded : Icons.date_range_rounded,
                                ),
                                onPressed: () async {
                                  final range = await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                    initialDateRange: provider.startDate != null && provider.endDate != null
                                        ? DateTimeRange(start: provider.startDate!, end: provider.endDate!)
                                        : null,
                                  );
                                  if (range != null) {
                                    provider.setDateRange(range.start, range.end);
                                  } else {
                                    provider.setDateRange(null, null);
                                  }
                                },
                              ),
                            ],
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
                            return TransactionTile(
                              transaction: t,
                              onDelete: () => provider.remove(t.id),
                              onEdit: () => _pushTransactionForm(context, initial: t),
                              dateFormat: _date,
                              moneyFormat: _money,
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
