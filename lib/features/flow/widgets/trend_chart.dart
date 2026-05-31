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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxValue = selectedPeriod == 'Weekly' ? 220 : 5000;
    final labelKey = selectedPeriod == 'Weekly' ? 'day' : 'month';

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
                        primaryColor,
                        primaryColor.withValues(alpha: 0.4),
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