// core/shared/widgets/greeting_name.dart
import 'dart:async';
import 'package:flutter/material.dart';

class GreetingName extends StatefulWidget {
  final String name;

  const GreetingName({
    super.key,
    required this.name,
  });

  @override
  State<GreetingName> createState() => _GreetingNameState();
}

class _GreetingNameState extends State<GreetingName> {
  // Initialise at declaration so the first frame never shows empty text.
  String _greeting = _greetingForHour(DateTime.now().hour);
  Timer? _timer;

  // Static so it can be called at field-init time (before `this` exists)
  // and inside the periodic callback without duplication.
  static String _greetingForHour(int hour) {
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final next = _greetingForHour(DateTime.now().hour);
      // Only rebuild when the greeting actually changes (boundary hour crossed).
      if (next != _greeting && mounted) {
        setState(() => _greeting = next);
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer so it doesn't outlive the widget.
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting,
          style: theme.textTheme.bodySmall,
        ),
        Text(
          widget.name,
          style: theme.textTheme.titleSmall,
        ),
      ],
    );
  }
}