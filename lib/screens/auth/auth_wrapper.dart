import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_ease/screens/auth/login_screen.dart';
import 'package:home_ease/screens/main_screen.dart';
import 'package:home_ease/screens/admin/admin_screen.dart';
import 'package:home_ease/screens/provider/provider_bookings_screen.dart';
import 'package:home_ease/services/admin_service.dart';
import 'package:home_ease/services/provider_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? currentUser;

  Widget? destinationScreen;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen(handleAuthState);
  }

  Future<void> handleAuthState(User? user) async {
    if (user == null) {
      if (!mounted) return;

      setState(() {
        currentUser = null;
        destinationScreen = const LoginScreen();
        isLoading = false;
      });

      return;
    }

    if (mounted) {
      setState(() {
        currentUser = user;
        destinationScreen = null;
        isLoading = true;
      });
    }

    try {
      final isAdmin = await AdminService.isAdmin(user.uid);

      if (isAdmin) {
        if (!mounted) return;

        setState(() {
          destinationScreen = const AdminScreen();
          isLoading = false;
        });

        return;
      }

      final provider = await ProviderService.getProviderByUid(user.uid);

      if (!mounted) return;

      if (provider != null) {
        setState(() {
          destinationScreen = const ProviderBookingsScreen();
          isLoading = false;
        });
      } else {
        setState(() {
          destinationScreen = const MainScreen();
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("AuthWrapper error: $e");

      if (!mounted) return;

      setState(() {
        destinationScreen = const MainScreen();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || destinationScreen == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return destinationScreen!;
  }
}
