import 'package:flutter/material.dart';

class AuthSubtext extends StatelessWidget {
  const AuthSubtext({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Keep your data safe and synchronous.',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey, fontSize: 16),
    );
  }
}
