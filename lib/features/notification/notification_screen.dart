// features/notifications/notification_screen.dart
import 'package:budgeto/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/models/notification_model.dart';
import '../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../../presentation/cubits/notification_cubit/notification_cubit/notification_cubit.dart';
import 'notification_settings_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  String _userId(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    return state is AuthAuthenticated ? state.user.id : '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = _userId(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.notifications,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        actions: [
          // Mark all read
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final hasUnread = state is NotificationLoaded &&
                  state.unreadCount > 0;
              if (!hasUnread) return const SizedBox.shrink();
              return TextButton(
                onPressed: () =>
                    context.read<NotificationCubit>().markAllAsRead(userId),
                child: Text(
                  AppStrings.markAllRead,
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              );
            },
          ),
          // Settings
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<NotificationCubit>(),
                    child: const NotificationSettingsScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.bellOff,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.noNotifications,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: state.notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return _NotificationTile(
                  notification: notification,
                  onTap: () {
                    if (!notification.isRead) {
                      context
                          .read<NotificationCubit>()
                          .markAsRead(userId, notification.id);
                    }
                  },
                  onDismissed: () {
                    context
                        .read<NotificationCubit>()
                        .deleteNotification(userId, notification.id);
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDismissed,
  });

  IconData _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.budgetWarning:
        return LucideIcons.alertTriangle;
      case NotificationType.transactionAdded:
        return LucideIcons.circleDollarSign;
      case NotificationType.weeklySummary:
      case NotificationType.monthlySummary:
        return LucideIcons.barChart2;
      case NotificationType.lowBalance:
        return LucideIcons.trendingDown;
    }
  }

  Color _colorFor(NotificationType type) {
    switch (type) {
      case NotificationType.budgetWarning:
        return Colors.orange;
      case NotificationType.transactionAdded:
        return Colors.blue;
      case NotificationType.weeklySummary:
      case NotificationType.monthlySummary:
        return Colors.purple;
      case NotificationType.lowBalance:
        return Colors.red;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return AppStrings.justNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes}${AppStrings.minutesAgo}';
    if (diff.inHours < 24) return '${diff.inHours}${AppStrings.hoursAgo}';
    if (diff.inDays < 7) return '${diff.inDays}${AppStrings.daysAgo}';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorFor(notification.type);
    final icon = _iconFor(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(LucideIcons.trash2, color: Colors.red),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead
                ? theme.cardColor
                : color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? Colors.transparent
                  : color.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _timeAgo(notification.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}