import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_ease/screens/auth/login_screen.dart';
import 'package:home_ease/screens/main_screen.dart';
import 'package:home_ease/screens/admin/admin_screen.dart';
import 'package:home_ease/services/admin_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isVerificationDialogShowing = false;

  String? allowedUnverifiedUserId;

  Future<void> showEmailVerificationDialog(User user) async {
    if (isVerificationDialogShowing) return;

    if (allowedUnverifiedUserId == user.uid) return;

    isVerificationDialogShowing = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Email Not Verified"),
          content: const Text(
            "Your email address has not been verified.\n\n"
            "Please verify your email to recover your account securely.\n\n"
            "If you are demonstrating the project, you may continue without verification.",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await user.sendEmailVerification();

                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Verification email sent successfully."),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.message ?? "Unable to send verification email.",
                      ),
                    ),
                  );
                }
              },
              child: const Text("Resend Email"),
            ),

            TextButton(
              onPressed: () {
                allowedUnverifiedUserId = user.uid;

                Navigator.pop(dialogContext);
              },
              child: const Text("Continue Anyway"),
            ),

            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (!dialogContext.mounted) return;

                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );

    isVerificationDialogShowing = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User is not logged in
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        final user = snapshot.data!;

        // If a different user logs in, reset the
        // "Continue Anyway" permission
        if (allowedUnverifiedUserId != user.uid) {
          if (user.emailVerified) {
            allowedUnverifiedUserId = null;
          }
        }

        // Unverified user
        if (!user.emailVerified && allowedUnverifiedUserId != user.uid) {
          if (!isVerificationDialogShowing) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;

              showEmailVerificationDialog(user);
            });
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check whether the logged-in user is an admin
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

            return const MainScreen();
          },
        );
      },
    );
  }
}
