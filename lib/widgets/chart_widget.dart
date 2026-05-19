import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../l10n/app_ar.dart';

/// Pie chart of **expense** totals by category using [fl_chart].
class ExpenseCategoryChart extends StatelessWidget {
  const ExpenseCategoryChart({super.key, required this.data});

  final Map<String, double> data;

  static const _palette = <Color>[
    Color(0xFF6366F1),
    Color(0xFF3B82F6),
    Color(0xFF14B8A6),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFFA855F7),
    Color(0xFF64748B),
    Color(0xFFCA8A04),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: scheme.surfaceContainerLowest,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 168,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.donut_large_rounded,
                  size: 40,
                  color: scheme.outline,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    AppStrings.chartPlaceholder,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold<double>(0, (s, e) => s + e.value);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: scheme.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.pie_chart_outline_rounded,
                      size: 20,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppStrings.expensesByCategory,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 46,
                          borderData: FlBorderData(show: false),
                          sections: List.generate(entries.length, (i) {
                            final e = entries[i];
                            final pct =
                                total == 0 ? 0.0 : (e.value / total * 100);
                            return PieChartSectionData(
                              color: _palette[i % _palette.length],
                              value: e.value,
                              title: '${pct.toStringAsFixed(0)}٪',
                              radius: 54,
                              titleStyle:
                                  theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                shadows: const [
                                  Shadow(
                                    blurRadius: 2,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (var i = 0; i < entries.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _palette[i % _palette.length],
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: _palette[i % _palette.length]
                                              .withValues(alpha: 0.45),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      AppStrings.categoryName(entries[i].key),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
