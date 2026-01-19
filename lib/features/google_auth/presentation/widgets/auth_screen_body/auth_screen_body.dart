import 'package:flutter/material.dart';
import 'package:week_28/core/const/strings.dart';
import 'package:week_28/core/widgets/centered_text.dart';
import 'package:week_28/features/google_auth/presentation/widgets/auth_screen_body/google_sign_in_text.dart';
import 'package:week_28/features/google_auth/presentation/widgets/login_button/login_button.dart';

class AuthScreenBody extends StatelessWidget {
  const AuthScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          CenteredText(text: AppStrings.welcomeBack),
          SizedBox(height: 10),
          Center(child: LoginButton()),
          GoogleSignInText(),
          Spacer(),
          Text('V 1.0.3+5')
        ],
      ),
    );
  }
}
