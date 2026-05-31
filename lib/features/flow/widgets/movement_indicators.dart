// features/flow/widgets/movement_indicators.dart
import 'package:flutter/material.dart';
import '../../../core/shared/widgets/card_container.dart';
import 'movement_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MovementIndicators extends StatelessWidget {
  final Color primaryColor;
  final double totalIncome;
  final double totalExpenses;
  final double incomeChange;
  final double expenseChange;

  const MovementIndicators({
    super.key,
    required this.primaryColor,
    required this.totalIncome,
    required this.totalExpenses,
    required this.incomeChange,
    required this.expenseChange,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Movement Direction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MovementCard(
                  title: 'Cash Inflow',
                  amount: '\$${totalIncome.toStringAsFixed(2)}',
                  change: '+${incomeChange.toStringAsFixed(1)}%',
                  icon: LucideIcons.trendingUp,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MovementCard(
                  title: 'Cash Outflow',
                  amount: '\$${totalExpenses.toStringAsFixed(2)}',
                  change: '-${expenseChange.toStringAsFixed(1)}%',
                  icon: LucideIcons.trendingDown,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}