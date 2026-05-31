// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SourceField extends StatelessWidget {
  final String? selectedSource;
  final ValueChanged<String?> onChanged;

  const SourceField({
    super.key,
    this.selectedSource,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Source',
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
            hint: const Text('Select source'),
            value: selectedSource,
            items: const [
              DropdownMenuItem(value: 'Salary', child: Text('Salary')),
              DropdownMenuItem(value: 'Freelance', child: Text('Freelance')),
              DropdownMenuItem(value: 'Investment', child: Text('Investment')),
              DropdownMenuItem(value: 'Gift', child: Text('Gift')),
              DropdownMenuItem(value: 'Refund', child: Text('Refund')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: onChanged,
            icon: Icon(LucideIcons.chevronDown, size: 20, color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}