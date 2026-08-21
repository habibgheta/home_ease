import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_ease/utils/app_colors.dart';
import 'package:home_ease/utils/app_strings.dart';
import 'package:home_ease/widgets/custom_button.dart';
import 'package:home_ease/widgets/custom_text_field.dart';
import 'package:home_ease/screens/auth/forgot_password_screen.dart';
import 'package:home_ease/screens/auth/register_choice_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseAuth.instance.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case "invalid-email":
          message = "Please enter a valid email.";
          break;

        case "user-not-found":
        case "invalid-credential":
        case "wrong-password":
          message = "Invalid email or password.";
          break;

        case "network-request-failed":
          message = "Please check your internet connection.";
          break;

        default:
          message = e.message ?? "Login failed.";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again."),
        ),
      );

      debugPrint("Login error: $e");
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
      appBar: AppBar(title: const Text(AppStrings.login)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/images/home_ease_logo.png', height: 150),

                  const SizedBox(height: 25),

                  const Text(
                    AppStrings.welcomeBack,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    AppStrings.signIn,
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),

                  const SizedBox(height: 35),

                  CustomTextField(
                    controller: emailController,
                    labelText: AppStrings.email,
                    hintText: "Enter your email",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
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

                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: passwordController,
                    labelText: AppStrings.password,
                    hintText: "Enter your password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }

                      if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }

                      return null;
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(AppStrings.forgotPassword),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  CustomButton(
                    text: AppStrings.login,
                    isLoading: isLoading,
                    onPressed: loginUser,
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(AppStrings.dontHaveAccount),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterChoiceScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          AppStrings.register,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
