import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week_28/core/const/strings.dart';
import 'package:week_28/core/utils/dialog_utils.dart';
import 'package:week_28/features/google_auth/presentation/bloc/auth_bloc.dart';

class HomeLogoutButton extends StatelessWidget {
  const HomeLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        DialogUtils.showConfirmationDialog(
          context: context,
          title: AppStrings.logout,
          content: AppStrings.logoutConfirmation,
          onConfirm: () {
            context.read<AuthBloc>().add(AuthSignOut());
          },
        );
      },
      icon: const Icon(Icons.logout),
    );
  }
}
