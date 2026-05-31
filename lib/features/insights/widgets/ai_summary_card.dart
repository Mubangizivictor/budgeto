// features/insights/widgets/ai_summary_card.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/shared/widgets/gradient_card.dart';
import 'ai_action_button.dart';

class AISummaryCard extends StatelessWidget {
  final int foodPercentage;
  final double totalSpending;

  const AISummaryCard({
    super.key,
    required this.foodPercentage,
    required this.totalSpending,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final savingsAmount = (totalSpending * 0.15).toStringAsFixed(0);

    return GradientCard(
      gradientColors: [
        theme.primaryColor,
        theme.primaryColor.withValues(alpha: 0.7),
        Colors.purple.withValues(alpha: 0.5),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('AI Summary', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'You spent $foodPercentage% more on food this month compared to last month. Consider dining in more often to save up to \$$savingsAmount monthly.',
            style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AIActionButton(label: 'Analyze', icon: LucideIcons.barChart),
              AIActionButton(label: 'Suggest', icon: LucideIcons.lightbulb),
              AIActionButton(label: 'Optimize', icon: LucideIcons.target),
            ],
          ),
        ],
      ),
    );
  }
}