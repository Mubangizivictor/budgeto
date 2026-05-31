// shared/widgets/gradient_card.dart
import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final List<Color>? gradientColors;
  final EdgeInsets padding;

  const GradientCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.gradientColors,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = gradientColors ?? [
      theme.primaryColor,
      theme.primaryColor.withValues(alpha: 0.8),
    ];

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}