import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:week_28/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week_28/init_dependencies.dart';
import 'package:week_28/features/google_auth/presentation/bloc/auth_bloc.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_event.dart';
import 'package:week_28/features/splash_screen/presentation/screens/splash_screen.dart';
import 'package:week_28/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(
          create: (_) => serviceLocator<TodoBloc>()..add(LoadTodos()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Pro',
      // Forcefully setting the primary theme to Dark
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}
