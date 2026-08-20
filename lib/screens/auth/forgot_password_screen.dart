import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_ease/widgets/custom_button.dart';
import 'package:home_ease/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Email Sent"),
          content: const Text(
            "If an account exists with this email, a password reset link "
            "has been sent to it.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case "invalid-email":
          message = "Please enter a valid email.";
          break;

        case "user-not-found":
          message = "No account exists with this email.";
          break;

        case "network-request-failed":
          message = "Please check your internet connection.";
          break;

        default:
          message = e.message ?? "Something went wrong.";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),

      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Icon(Icons.lock_reset, size: 80),

              const SizedBox(height: 30),

              const Text(
                "Enter your registered email address.",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              CustomTextField(
                controller: emailController,
                labelText: "Email",
                hintText: "Enter your email",
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your email";
                  }

                  if (!value.contains("@") || !value.contains(".")) {
                    return "Please enter a valid email";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: "Send Reset Link",
                isLoading: isLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    resetPassword();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
