// main.dart
import 'dart:developer';
import 'package:budgeto/presentation/cubits/notification_cubit/notification_cubit/notification_cubit.dart';

import 'core/local_storage/hive_service.dart';
import 'core/notifications/notification_manager.dart';
import 'core/splash/splash_screen.dart';
import 'package:budgeto/core/theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/boarding/boarding_screen.dart';
import 'core/injection_container.dart' as di;
import 'features/auth/presentation/screens/login_screen.dart';
import 'firebase_options.dart';
import 'main_nav_screen.dart';
import 'presentation/cubits/auth_cubits/auth_cubit.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    log('Starting Budgeto...');

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('Firebase initialized');

    // Enable offline persistence for Firestore.
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Initializing Hive for my local storage
    await HiveService.init();
    log('Hive initialized');

    // Initialize Dependency Injection
    await di.init();
    log('DI initialized');

    // Setting up notifications
    // We get it from DI to ensure we use the same instance throughout the app
    final notificationManager = di.sl<NotificationManager>();
    await notificationManager.init().catchError((e) {
      log('Notification Manager initialization failed: $e');
    });
    log('Notifications initialized');

    runApp(const MyApp());
  } catch (e, stackTrace) {
    log('Error during initialization: $e', stackTrace: stackTrace);
    // Even if initialization fails partially, we try to run the app
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.sl<AuthCubit>()..checkAuthStatus(),
          ),
          BlocProvider(
            create: (context) => di.sl<NotificationCubit>(),
          ),
        ],
        child: const AppRoot(),
      ),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Budgeto',
      theme: themeProvider.themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/boarding': (context) => const BoardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainNavScreen(),
      },
    );
  }
}