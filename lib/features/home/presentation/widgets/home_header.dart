// features/home/presentation/widgets/home_header.dart
import 'package:flutter/material.dart';
import '../../../home/presentation/widgets/period_chip.dart';

/// The period options available on the home screen.
enum Period {
  thisMonth('This month'),
  lastMonth('Last month'),
  thisYear('This year');

  final String label;
  const Period(this.label);
}

/// A row of pill chips that let the user switch the active period.
/// Fires [onPeriodChanged] immediately on first build and on every tap.
class HomeHeader extends StatefulWidget {
  final ValueChanged<DateTimeRange> onPeriodChanged;

  const HomeHeader({
    super.key,
    required this.onPeriodChanged,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  Period _selected = Period.thisMonth;

  static DateTimeRange _rangeFor(Period period) {
    final now = DateTime.now();
    switch (period) {
      case Period.thisMonth:
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
        );
      case Period.lastMonth:
        return DateTimeRange(
          start: DateTime(now.year, now.month - 1, 1),
          end: DateTime(now.year, now.month, 0, 23, 59, 59),
        );
      case Period.thisYear:
        return DateTimeRange(
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year, 12, 31, 23, 59, 59),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onPeriodChanged(_rangeFor(_selected));
    });
  }

  void _onTap(Period period) {
    if (_selected == period) return;
    setState(() => _selected = period);
    widget.onPeriodChanged(_rangeFor(period));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Period.values.map((period) {
        final isLast = period == Period.values.last;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: PeriodChip(
              label: period.label,
              isSelected: _selected == period,
              onTap: () => _onTap(period),
            ),
          ),
        );
      }).toList(),
    );
  }
}