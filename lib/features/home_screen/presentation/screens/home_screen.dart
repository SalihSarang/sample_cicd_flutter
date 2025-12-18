import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week_28/core/utils/navigator_utils.dart';
import 'package:week_28/core/utils/snackbar_utils.dart';
import 'package:week_28/features/google_auth/presentation/bloc/auth_bloc.dart';
import 'package:week_28/features/google_auth/presentation/screens/auth_screen.dart';
import 'package:week_28/features/home_screen/presentation/widgets/home_screen_body.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger loading todos as soon as the home screen is initialized
    context.read<TodoBloc>().add(LoadTodos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          NavigatorUtils.pushAndRemoveUntil(context, const AuthScreen());
        } else if (state is AuthFailure) {
          SnackbarUtils.showSnackBar(context, state.message);
        }
      },
      child: const HomeScreenBody(),
    );
  }
}
