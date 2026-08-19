import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_ease/screens/admin/providers/admin_providers_screen.dart';
import 'package:home_ease/screens/admin/categories/admin_categories_screen.dart';
import 'package:home_ease/screens/admin/bookings/admin_bookings_screen.dart';
import 'package:home_ease/screens/admin/users/admin_users_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _AdminOption(
            icon: Icons.category,
            title: "Categories",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminCategoriesScreen(),
                ),
              );
            },
          ),
          _AdminOption(
            icon: Icons.engineering,
            title: "Service Providers",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminProvidersScreen(),
                ),
              );
            },
          ),
          _AdminOption(
            icon: Icons.people,
            title: "Users",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminUsersScreen(),
                ),
              );
            },
          ),
          _AdminOption(
            icon: Icons.calendar_month,
            title: "Bookings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminBookingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AdminOption extends StatelessWidget {
  const _AdminOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
