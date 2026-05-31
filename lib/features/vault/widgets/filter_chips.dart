// shared/widgets/filter_chips.dart
import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          return FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) => onFilterSelected(filter),
            backgroundColor: theme.cardColor,
            selectedColor: theme.primaryColor.withValues(alpha: 0.2),
            labelStyle: TextStyle(
              color: isSelected ? theme.primaryColor : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }
}