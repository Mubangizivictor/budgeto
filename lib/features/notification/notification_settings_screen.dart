// features/notifications/notification_settings_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/models/notification_settings_model.dart';
import '../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../../presentation/cubits/notification_cubit/notification_cubit/notification_cubit.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  late NotificationSettingsModel _settings;
  bool _initialised = false;

  String get _userId {
    final state = context.read<AuthCubit>().state;
    return state is AuthAuthenticated ? state.user.id : '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        // Initialise local settings from cubit once.
        if (!_initialised && state is NotificationLoaded) {
          _settings = state.settings;
          _initialised = true;
        } else if (!_initialised) {
          _settings = const NotificationSettingsModel();
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(
              'Notification Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            centerTitle: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _SectionLabel(label: 'Transaction Alerts'),
              _SettingsTile(
                icon: LucideIcons.circleDollarSign,
                iconColor: Colors.blue,
                title: 'New Transaction',
                subtitle:
                'Get notified when you add an expense or income',
                value: _settings.transactionAdded,
                onChanged: (val) => _update(
                    _settings.copyWith(transactionAdded: val)),
              ),
              const SizedBox(height: 8),
              _SettingsTile(
                icon: LucideIcons.alertTriangle,
                iconColor: Colors.orange,
                title: 'Budget Warnings',
                subtitle:
                'Alert when a category reaches 80% or 100% of its limit',
                value: _settings.budgetWarnings,
                onChanged: (val) =>
                    _update(_settings.copyWith(budgetWarnings: val)),
              ),
              const SizedBox(height: 8),
              _SettingsTile(
                icon: LucideIcons.trendingDown,
                iconColor: Colors.red,
                title: 'Low Balance Alert',
                subtitle:
                'Alert when your balance drops below your threshold',
                value: _settings.lowBalance,
                onChanged: (val) =>
                    _update(_settings.copyWith(lowBalance: val)),
              ),
              if (_settings.lowBalance) ...[
                const SizedBox(height: 12),
                _ThresholdSlider(
                  value: _settings.lowBalanceThreshold,
                  onChanged: (val) => _update(
                      _settings.copyWith(lowBalanceThreshold: val)),
                ),
              ],
              const SizedBox(height: 24),
              _SectionLabel(label: 'Summaries'),
              _SettingsTile(
                icon: LucideIcons.calendarDays,
                iconColor: Colors.purple,
                title: 'Weekly Summary',
                subtitle: 'A weekly snapshot of your income and expenses',
                value: _settings.weeklySummary,
                onChanged: (val) =>
                    _update(_settings.copyWith(weeklySummary: val)),
              ),
              const SizedBox(height: 8),
              _SettingsTile(
                icon: LucideIcons.barChart2,
                iconColor: Colors.teal,
                title: 'Monthly Summary',
                subtitle: 'A monthly report of your cash flow',
                value: _settings.monthlySummary,
                onChanged: (val) =>
                    _update(_settings.copyWith(monthlySummary: val)),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _update(NotificationSettingsModel updated) {
    setState(() => _settings = updated);
  }

  void _save() {
    context
        .read<NotificationCubit>()
        .saveSettings(_userId, _settings);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _ThresholdSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _ThresholdSlider(
      {required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Low Balance Threshold',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              Text(
                '\$${value.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: 0,
            max: 1000,
            divisions: 20,
            activeColor: theme.colorScheme.primary,
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$0', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              Text('\$1000',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }
}