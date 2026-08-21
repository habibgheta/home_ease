import 'package:flutter/material.dart';
import 'package:home_ease/screens/auth/register_screen.dart';
import 'package:home_ease/screens/auth/provider_register_screen.dart';

class RegisterChoiceScreen extends StatelessWidget {
  const RegisterChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add, size: 80),

            const SizedBox(height: 30),

            const Text(
              "Create Account",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Choose how you want to register",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.person),
                label: const Text("Register as User"),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProviderRegisterScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.engineering),
                label: const Text("Register as Service Provider"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
