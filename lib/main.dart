import 'package:flutter/material.dart';
import 'package:home_ease/screens/auth/login_screen.dart';
import 'package:home_ease/screens/main_screen.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'package:home_ease/screens/home/home_screen.dart';

void main() {
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
