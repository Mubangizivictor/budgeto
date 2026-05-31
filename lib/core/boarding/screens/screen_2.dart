// screen_2.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),

            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                    theme.colorScheme.primaryContainer,
                    theme.scaffoldBackgroundColor,
                  ]
                      : [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.surface,
                  ],
                ),
              ),
              child: Center(
                child: Lottie.asset('assets/animations/screen_2.json'),
              ),
            ),

            const SizedBox(height: 60),

            Text(
              "Smart Budget Planning",
              style: theme.textTheme.titleLarge,
            ),

            const SizedBox(height: 20),

            Text(
              "Set monthly budgets, control overspending, and build better money habits effortlessly.",
              style: theme.textTheme.bodyMedium,
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}