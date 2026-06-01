// presentation/screens/main_nav_screen.dart
import 'package:budgeto/presentation/cubits/auth_cubits/auth_cubit.dart';
import 'package:budgeto/presentation/cubits/expense_cubits/expense_cubit.dart';
import 'package:budgeto/presentation/cubits/income_cubit/income_cubit.dart';
import 'package:budgeto/presentation/cubits/export_cubit/export_cubit.dart';
import 'package:budgeto/presentation/cubits/notification_cubit/notification_cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../features/flow/flow_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/insights/insight_screen.dart';
import '../../features/vault/vault_screen.dart';
import '../../features/add_income_expense/main_fab.dart';
import '../../features/add_income_expense/transaction_type_modal.dart';
import 'core/injection_container.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int selectedIndex = 0;
  bool _dataLoaded = false;

  late final ExpenseCubit _expenseCubit;
  late final IncomeCubit _incomeCubit;
  late final NotificationCubit _notificationCubit;
  late final ExportCubit _exportCubit;

  final List<Widget> screens = const [
    HomeScreen(),
    FlowScreen(),
    VaultScreen(),
    InsightScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _expenseCubit = sl<ExpenseCubit>();
    _incomeCubit = sl<IncomeCubit>();
    _notificationCubit = sl<NotificationCubit>();
    _exportCubit = sl<ExportCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataLoaded) {
      _dataLoaded = true;
      _loadUserDataIfLoggedIn();
    }
  }

  void _loadUserDataIfLoggedIn() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final userId = authState.user.id;
      if (userId.isNotEmpty) {
        _expenseCubit.getExpenses(userId);
        _incomeCubit.getIncome(userId);
        _notificationCubit.init(userId);
      }
    }
  }

  void _onTabChanged(int index) {
    setState(() => selectedIndex = index);
  }

  void _showTransactionTypeModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionTypeModal(
        expenseCubit: _expenseCubit,
        incomeCubit: _incomeCubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<AuthCubit>()),
        BlocProvider.value(value: _expenseCubit),
        BlocProvider.value(value: _incomeCubit),
        BlocProvider.value(value: _notificationCubit),
        BlocProvider.value(value: _exportCubit),
      ],
      child: Scaffold(
        extendBody: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: IndexedStack(
          index: selectedIndex,
          children: screens,
        ),
        floatingActionButton: MainFab(onPressed: _showTransactionTypeModal),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                indicatorColor:
                theme.colorScheme.primary.withValues(alpha: 0.15),
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                labelTextStyle:
                WidgetStateProperty.resolveWith((states) {
                  final selected = states.contains(WidgetState.selected);
                  return theme.textTheme.bodySmall?.copyWith(
                    fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 12,
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  );
                }),
              ),
              child: NavigationBar(
                height: 72,
                elevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                selectedIndex: selectedIndex,
                onDestinationSelected: _onTabChanged,
                destinations: [
                  NavigationDestination(
                    icon: Icon(LucideIcons.layoutDashboard,
                        size: 22,
                        color: isDarkMode ? Colors.grey[400] : null),
                    selectedIcon: Icon(LucideIcons.layoutDashboard,
                        size: 24,
                        color: isDarkMode
                            ? Colors.white
                            : theme.colorScheme.primary),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(LucideIcons.trendingUp,
                        size: 22,
                        color: isDarkMode ? Colors.grey[400] : null),
                    selectedIcon: Icon(LucideIcons.trendingUp,
                        size: 24,
                        color: isDarkMode
                            ? Colors.white
                            : theme.colorScheme.primary),
                    label: 'Flow',
                  ),
                  NavigationDestination(
                    icon: Icon(LucideIcons.wallet,
                        size: 22,
                        color: isDarkMode ? Colors.grey[400] : null),
                    selectedIcon: Icon(LucideIcons.wallet,
                        size: 24,
                        color: isDarkMode
                            ? Colors.white
                            : theme.colorScheme.primary),
                    label: 'Vault',
                  ),
                  NavigationDestination(
                    icon: Icon(LucideIcons.sparkles,
                        size: 22,
                        color: isDarkMode ? Colors.grey[400] : null),
                    selectedIcon: Icon(LucideIcons.sparkles,
                        size: 24,
                        color: isDarkMode
                            ? Colors.white
                            : theme.colorScheme.primary),
                    label: 'Insights',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}