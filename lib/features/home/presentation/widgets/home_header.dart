// features/home/presentation/widgets/home_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared/widgets/greeting_name.dart';
import '../../../../core/shared/widgets/profile_avatar.dart';
import '../../../../presentation/cubits/auth_cubits/auth_cubit.dart';
import 'period_dropdown.dart';

class HomeHeader extends StatefulWidget {
  /// Called whenever the user picks a different period, and once on first
  /// build with the default (this month) range.
  final ValueChanged<DateTimeRange> onPeriodChanged;

  const HomeHeader({
    super.key,
    required this.onPeriodChanged,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  Period _selectedPeriod = Period.thisMonth;

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
    // Fire the initial range after the first frame so the parent screen
    // has finished building before receiving the callback.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onPeriodChanged(_rangeFor(_selectedPeriod));
    });
  }

  void _onPeriodChanged(Period period) {
    setState(() => _selectedPeriod = period);
    widget.onPeriodChanged(_rangeFor(period));
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final userName =
    authState is AuthAuthenticated ? authState.user.fullName : '';

    return Row(
      children: [
        GestureDetector( onTap: (){Scaffold.of(context).openDrawer();},
          child: const ProfileAvatar(
            imagePath: 'assets/images/my_profile_pic.jpeg',
          ),
        ),
        const SizedBox(width: 10),
        GreetingName(name: userName),
        const Spacer(),
        PeriodDropdown(
          selectedPeriod: _selectedPeriod,
          onChanged: _onPeriodChanged,
        ),
      ],
    );
  }
}