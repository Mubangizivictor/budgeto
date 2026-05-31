// features/home/presentation/widgets/period_dropdown.dart
import 'package:flutter/material.dart';

/// Strongly-typed period options. Using an enum avoids string typos and
/// makes exhaustive switch statements possible.
enum Period {
  thisMonth('This month'),
  lastMonth('Last month'),
  thisYear('This year');

  final String label;
  const Period(this.label);
}

/// Fully controlled — no internal state. The parent owns [selectedPeriod]
/// and reacts to [onChanged].
class PeriodDropdown extends StatelessWidget {
  final Period selectedPeriod;
  final ValueChanged<Period> onChanged;

  const PeriodDropdown({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Period>(
          value: selectedPeriod,
          icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
          style: theme.textTheme.bodyMedium,
          items: Period.values
              .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }
}