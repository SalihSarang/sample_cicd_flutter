import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week_28/features/google_auth/presentation/bloc/auth_bloc.dart';
import 'package:week_28/features/google_auth/presentation/widgets/auth_loading_state/auth_loading_state.dart';
import 'package:week_28/core/utils/navigator_utils.dart';
import 'package:week_28/core/utils/snackbar_utils.dart';
import 'package:week_28/features/google_auth/presentation/widgets/auth_screen_body/auth_screen_body.dart';
import 'package:week_28/features/home_screen/presentation/screens/home_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            SnackbarUtils.showSnackBar(context, state.message);
          }
          if (state is AuthSuccess) {
            NavigatorUtils.pushReplacement(context, const HomeScreen());
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const AuthLoadingState();
          }
          return const AuthScreenBody();
        },
      ),
    );
  }
}
