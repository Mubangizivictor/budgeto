// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PaymentMethodField extends StatelessWidget {
  final String selectedPaymentMethod;
  final ValueChanged<String?> onChanged;

  const PaymentMethodField({
    super.key,
    required this.selectedPaymentMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: InputBorder.none),
            value: selectedPaymentMethod,
            items: const [
              DropdownMenuItem(value: 'Cash', child: Text('Cash')),
              DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card')),
              DropdownMenuItem(value: 'Debit Card', child: Text('Debit Card')),
              DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer')),
              DropdownMenuItem(value: 'Mobile Money', child: Text('Mobile Money')),
            ],
            onChanged: onChanged,
            icon: Icon(LucideIcons.chevronDown, size: 20, color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}