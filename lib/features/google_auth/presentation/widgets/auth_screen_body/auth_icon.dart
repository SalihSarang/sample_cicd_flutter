import 'package:flutter/material.dart';

class AuthIcon extends StatelessWidget {
  const AuthIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.lock_outline_rounded,
      size: 100,
      color: Colors.black,
    );
  }
}
