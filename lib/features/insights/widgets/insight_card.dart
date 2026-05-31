// shared/widgets/insight_card.dart
import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  final String category;
  final String change;
  final String insight;
  final String type;

  const InsightCard({
    super.key,
    required this.category,
    required this.change,
    required this.insight,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isWarning = type == 'warning';
    final color = isWarning ? Colors.red : Colors.green;
    final icon = isWarning ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(insight, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Text(
            change,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}