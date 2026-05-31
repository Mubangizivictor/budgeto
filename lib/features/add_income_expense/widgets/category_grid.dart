import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: categories.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategory == category['name'];

            return GestureDetector(
              onTap: () => onCategorySelected(category['name'] as String),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (category['color'] as Color).withValues(alpha: 0.2)
                          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? category['color'] as Color : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      color: isSelected
                          ? category['color'] as Color
                          : theme.colorScheme.onSurfaceVariant,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category['name'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected
                          ? category['color'] as Color
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}