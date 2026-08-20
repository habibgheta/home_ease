import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_ease/screens/auth/login_screen.dart';
import 'package:home_ease/screens/main_screen.dart';
import 'package:home_ease/screens/admin/admin_screen.dart';
import 'package:home_ease/services/admin_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Firebase is checking the authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // No user is logged in
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        final user = snapshot.data!;

        // Check whether the logged-in user is an admin
        return FutureBuilder<bool>(
          future: AdminService.isAdmin(user.uid),
          builder: (context, adminSnapshot) {
            // Checking admin status
            if (adminSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Logged-in admin
            if (adminSnapshot.data == true) {
              return const AdminScreen();
            }

            // Logged-in normal user
            return const MainScreen();
          },
        );
      },
    );
  }
}
