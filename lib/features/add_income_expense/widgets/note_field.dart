import 'package:flutter/material.dart';

class NoteField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const NoteField({
    super.key,
    required this.controller,
    this.hintText = 'What was this for?',
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note (Optional)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}