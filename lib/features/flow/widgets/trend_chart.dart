// core/shared/widgets/trend_chart.dart
import 'package:flutter/material.dart';

class TrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String selectedPeriod;
  final Color primaryColor;

  const TrendChart({
    super.key,
    required this.data,
    required this.selectedPeriod,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelKey = selectedPeriod == 'Weekly' ? 'day' : 'month';

    // Scale bars against the actual data range instead of an assumed
    // fixed ceiling, so real (not demo) amounts always render sensibly.
    final maxValue = data.isEmpty
        ? 1
        : data
            .map((d) => d['value'] as num)
            .fold<num>(0, (max, v) => v > max ? v : max)
            .clamp(1, double.infinity);

    // Get a brighter version of primary color for dark mode
    final barColor = isDark
        ? theme.colorScheme.primary
        : primaryColor;

    final barLightColor = isDark
        ? theme.colorScheme.primary.withValues(alpha: 0.6)
        : primaryColor.withValues(alpha: 0.3);

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(data.length, (index) {
          final value = data[index]['value'] as int;
          final height = (value / maxValue) * 150;
          final label = data[index][labelKey] as String;

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: height,
                  width: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        barColor,
                        barLightColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}