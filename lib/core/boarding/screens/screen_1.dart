// screen_1.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

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
                child: Lottie.asset('assets/animations/screen_1.json'),
              ),
            ),

            const SizedBox(height: 60),

            Text(
              "Track Your Expenses Easily",
              style: theme.textTheme.titleLarge,
            ),

            const SizedBox(height: 20),

            Text(
              "Monitor your spending, manage budgets, and stay financially organized with Budgeto.",
              style: theme.textTheme.bodyMedium,
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}