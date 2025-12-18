import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week_28/core/const/strings.dart';
import 'package:week_28/features/google_auth/presentation/bloc/auth_bloc.dart';
import 'package:week_28/features/google_auth/presentation/screens/auth_screen.dart';
import 'package:week_28/features/home_screen/presentation/screens/home_screen.dart';
import 'package:week_28/core/utils/navigator_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatus());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          NavigatorUtils.pushReplacement(context, const HomeScreen());
        } else if (state is AuthUnauthenticated || state is AuthFailure) {
          NavigatorUtils.pushReplacement(context, const AuthScreen());
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF000000) : theme.primaryColor,
            gradient: isDark
                ? null
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: isDark ? Colors.tealAccent : Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.appTitle,
                style: TextStyle(
                  color: isDark ? Colors.tealAccent : Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 48),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? Colors.tealAccent : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
