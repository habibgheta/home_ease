import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_ease/screens/auth/auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDarkMode ? Colors.white : const Color(0xFF172B6B);

    final developedByColor = isDarkMode
        ? Colors.blueGrey.shade300
        : Colors.blueGrey;

    final nameColor = isDarkMode ? Colors.white : const Color(0xFF172B6B);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/home_ease_logo.png",
                      width: 190,
                      height: 190,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "HomeEase",
                      style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Column(
                children: [
                  Text(
                    "Developed by",
                    style: TextStyle(fontSize: 18, color: developedByColor),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "Habib Gheta",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: nameColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
