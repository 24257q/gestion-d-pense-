import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_strings.dart';
import '../l10n/app_ar.dart';

class DashboardCharts extends StatelessWidget {
  const DashboardCharts({
    super.key,
    required this.pieData,
    required this.weeklyData,
  });

  final Map<String, double> pieData;
  final List<double> weeklyData;

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
    return Column(
      children: [
        _buildPieChart(context),
        const SizedBox(height: 16),
        _buildBarChart(context),
      ],
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (pieData.isEmpty) {
      return const SizedBox.shrink();
    }

    final entries = pieData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold<double>(0, (s, e) => s + e.value);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: scheme.surface,
        elevation: theme.cardTheme.elevation ?? 0,
        shadowColor: theme.cardTheme.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.expensesByCategory,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          borderData: FlBorderData(show: false),
                          sections: List.generate(entries.length, (i) {
                            final e = entries[i];
                            final pct = total == 0 ? 0.0 : (e.value / total * 100);
                            return PieChartSectionData(
                              color: _palette[i % _palette.length],
                              value: e.value,
                              title: '${pct.toStringAsFixed(0)}%',
                              radius: 40,
                              titleStyle: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (var i = 0; i < entries.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: _palette[i % _palette.length],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      AppStrings.categoryName(entries[i].key),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
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

  Widget _buildBarChart(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasData = weeklyData.any((v) => v > 0);

    if (!hasData) return const SizedBox.shrink();

    final now = DateTime.now();
    final dateFormat = DateFormat.E(AppStrings.currentLang); // e.g. "Mon"

    double maxY = weeklyData.reduce((a, b) => a > b ? a : b);
    if (maxY == 0) maxY = 100;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: scheme.surface,
        elevation: theme.cardTheme.elevation ?? 0,
        shadowColor: theme.cardTheme.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.currentLang == 'fr' ? 'Dépenses des 7 derniers jours' : 'Last 7 Days Expenses',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY * 1.2,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index > 6) return const SizedBox.shrink();
                            // index 6 is today
                            final date = now.subtract(Duration(days: 6 - index));
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                dateFormat.format(date),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(7, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: weeklyData[i],
                            color: scheme.primary,
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
