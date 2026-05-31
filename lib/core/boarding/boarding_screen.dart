// core/boarding/boarding_screen.dart
import 'package:budgeto/core/boarding/screens/screen_1.dart';
import 'package:budgeto/core/boarding/screens/screen_2.dart';
import 'package:budgeto/core/boarding/screens/screen_3.dart';
import 'package:budgeto/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  final PageController _pageController = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => onLastPage = index == 2);
            },
            children: const [
              Screen1(),
              Screen2(),
              Screen3(),
            ],
          ),
          Positioned(
            top: 60,
            right: 20,
            child: TextButton(
              onPressed: () => _pageController.jumpToPage(2),
              child: Text(
                "Skip",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          Positioned(
            bottom: 55,
            left: 30,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: theme.colorScheme.primary,
                dotColor: theme.colorScheme.primaryContainer,
              ),
            ),
          ),
          Positioned(
            bottom: 35,
            right: 20,
            child: onLastPage
                ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  // Navigate to login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text("Get Started"),
              ),
            )
                : TextButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                "Next",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}