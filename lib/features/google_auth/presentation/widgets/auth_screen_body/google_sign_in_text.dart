import 'package:flutter/material.dart';
import 'package:week_28/core/const/strings.dart';

class GoogleSignInText extends StatelessWidget {
  const GoogleSignInText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          AppStrings.signInWithGoogle,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
