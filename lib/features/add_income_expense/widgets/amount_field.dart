import 'package:flutter/material.dart';

class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;

  const AmountField({
    super.key,
    required this.controller,
    this.autofocus = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          autofocus: autofocus,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            hintText: '0.00',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
        ),
      ],
    );
  }
}