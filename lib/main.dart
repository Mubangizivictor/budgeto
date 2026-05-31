// main.dart
import 'package:budgeto/core/splash/splash_screen.dart';
import 'package:budgeto/core/theme/theme_provider.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await di.init();

  runApp(const MyApp());
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