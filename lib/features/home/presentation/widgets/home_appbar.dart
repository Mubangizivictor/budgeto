// features/home/presentation/widgets/home_appbar.dart
// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/shared/widgets/custom_icon_button.dart';
import '../../../../core/shared/widgets/notification_bell.dart';
import '../../../../core/shared/widgets/export_button.dart';
import '../../../../core/shared/widgets/profile_avatar.dart';
import '../../../../core/shared/widgets/greeting_name.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../presentation/cubits/auth_cubits/auth_cubit.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final authState = context.watch<AuthCubit>().state;
    final userName =
    authState is AuthAuthenticated ? authState.user.fullName : '';
    final photoUrl =
    authState is AuthAuthenticated ? authState.user.photoUrl : null;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          ProfileAvatar(
            size: 38,
            iconSize: 20,
            photoUrl: photoUrl,
            onTap: () => Scaffold.of(context).openDrawer(),
          ),
          const SizedBox(width: 10),
          GreetingName(name: userName),
        ],
      ),
      actionsPadding: EdgeInsets.only(right: 10),
      actions: [
        CustomIconButton(
          icon: theme.brightness == Brightness.dark
              ? LucideIcons.moon
              : LucideIcons.sun,
          onTap: () => themeProvider.toggleTheme(),
        ),
        const SizedBox(width: 4),
        const ExportButton(),
        const SizedBox(width: 4),
        const NotificationBell(),
        const SizedBox(width: 4),
      ],
    );
  }
}