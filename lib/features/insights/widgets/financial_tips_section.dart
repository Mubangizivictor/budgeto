import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'tip_card.dart';

class FinancialTipsSection extends StatelessWidget {
  const FinancialTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const tips = [
      TipCard(tip: 'Set a daily spending limit of \$50', icon: LucideIcons.target, savings: 'Save \$200/mo'),
      TipCard(tip: 'Cancel unused subscriptions', icon: LucideIcons.bellOff, savings: 'Save \$45/mo'),
      TipCard(tip: 'Cook at home 3 more days this week', icon: LucideIcons.cookingPot, savings: 'Save \$60/mo'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withValues(alpha: 0.1), Colors.blue.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.lightbulb, size: 20, color: Colors.amber),
              SizedBox(width: 8),
              Text('Financial Tips for You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: tip,
          )),
        ],
      ),
    );
  }
}