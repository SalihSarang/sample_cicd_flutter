import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:week_28/features/google_auth/presentation/screens/auth_screen.dart';
import 'package:week_28/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthScreen());
  }
}
