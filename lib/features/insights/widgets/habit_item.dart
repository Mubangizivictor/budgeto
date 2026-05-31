// shared/widgets/habit_item.dart
import 'package:flutter/material.dart';

class HabitItem extends StatelessWidget {
  final String habit;
  final int percentage;
  final String insight;
  final Color color;

  const HabitItem({
    super.key,
    required this.habit,
    required this.percentage,
    required this.insight,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(habit, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('$percentage%', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey.withValues(alpha: 0.1),
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Text(insight, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}