import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_ease/screens/auth/login_screen.dart';
import 'package:home_ease/screens/main_screen.dart';
import 'package:home_ease/screens/admin/admin_screen.dart';
import 'package:home_ease/screens/provider/provider_bookings_screen.dart';
import 'package:home_ease/services/admin_service.dart';
import 'package:home_ease/services/provider_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        final user = snapshot.data!;

        return FutureBuilder<bool>(
          future: AdminService.isAdmin(user.uid),
          builder: (context, adminSnapshot) {
            if (adminSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (adminSnapshot.data == true) {
              return const AdminScreen();
            }

            return FutureBuilder(
              future: ProviderService.getProviderByUid(user.uid),
              builder: (context, providerSnapshot) {
                if (providerSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (providerSnapshot.data != null) {
                  return const ProviderBookingsScreen();
                }

                return const MainScreen();
              },
            );
          },
        );
      },
    );
  }
}
