import 'package:budgeto/features/vault/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'transaction_item.dart';

class TransactionGroup extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> transactions;

  const TransactionGroup({
    super.key,
    required this.title,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VaultSectionHeader(title: title),
        ...transactions.map((tx) => TransactionItem(
          title: tx['title'] as String,
          amount: tx['amount'] as String,
          category: tx['category'] as String,
          icon: tx['icon'] as IconData,
          iconColor: tx['iconColor'] as Color,
          isIncome: tx['isIncome'] as bool? ?? false,
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}