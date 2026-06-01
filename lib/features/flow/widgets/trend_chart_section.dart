// features/flow/widgets/trend_chart_section.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/shared/widgets/card_container.dart';
import 'trend_chart.dart';
import 'chart_legend.dart';

class TrendChartSection extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String selectedPeriod;
  final Color primaryColor;

  const TrendChartSection({
    super.key,
    required this.data,
    required this.selectedPeriod,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spending Trends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: isDark ? Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                    width: 0.5,
                  ) : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.lineChart,
                      size: 16,
                      color: isDark ? Colors.white : primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Interactive Chart',
                      style: TextStyle(
                        color: isDark ? Colors.white : primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TrendChart(
            data: data,
            selectedPeriod: selectedPeriod,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 16),
          Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChartLegend(label: 'Income', color: Colors.green),
              const SizedBox(width: 24),
              ChartLegend(label: 'Expenses', color: primaryColor),
            ],
          ),
        ],
      ),
    );
  }
}