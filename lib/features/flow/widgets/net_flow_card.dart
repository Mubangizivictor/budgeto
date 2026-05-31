// features/flow/widgets/net_flow_card.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/shared/widgets/gradient_card.dart';

class NetFlowCard extends StatelessWidget {
  final double netFlow;
  final double percentageChange;
  final bool isPositive;

  const NetFlowCard({
    super.key,
    required this.netFlow,
    required this.percentageChange,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Net Cash Flow', style: TextStyle(color: Colors.white70)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}${percentageChange.toStringAsFixed(1)}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '\$${netFlow.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text('vs last period', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}