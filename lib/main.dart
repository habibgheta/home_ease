import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_ease/firebase_options.dart';
import 'package:home_ease/screens/main_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const HomeEaseApp());
}

class HomeEaseApp extends StatelessWidget {
  const HomeEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomeEase',
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
