import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_ease/main.dart';
import 'package:home_ease/screens/admin/bookings/admin_bookings_screen.dart';
import 'package:home_ease/screens/admin/categories/admin_categories_screen.dart';
import 'package:home_ease/screens/admin/providers/admin_providers_screen.dart';
import 'package:home_ease/screens/admin/users/admin_users_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Mobile and tablet = 1 column
    // PC = 2 columns
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: HomeEaseApp.themeMode,
            builder: (context, themeMode, child) {
              final isDarkMode = themeMode == ThemeMode.dark;

              return Switch(
                value: isDarkMode,
                onChanged: (value) {
                  HomeEaseApp.themeMode.value = value
                      ? ThemeMode.dark
                      : ThemeMode.light;
                },
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: 4,

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 2 : 1,

          crossAxisSpacing: 16,
          mainAxisSpacing: 16,

          // Fixed height prevents text overflow
          mainAxisExtent: isDesktop ? 150 : 120,
        ),

        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return _AdminOption(
                icon: Icons.category,
                title: "Categories",
                subtitle: "Manage service categories",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminCategoriesScreen(),
                    ),
                  );
                },
              );

            case 1:
              return _AdminOption(
                icon: Icons.engineering,
                title: "Service Providers",
                subtitle: "Manage professionals",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminProvidersScreen(),
                    ),
                  );
                },
              );

            case 2:
              return _AdminOption(
                icon: Icons.people,
                title: "Users",
                subtitle: "Manage registered users",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminUsersScreen(),
                    ),
                  );
                },
              );

            default:
              return _AdminOption(
                icon: Icons.calendar_month,
                title: "Bookings",
                subtitle: "Manage customer bookings",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminBookingsScreen(),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class _AdminOption extends StatelessWidget {
  const _AdminOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 34, color: theme.colorScheme.primary),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      softWrap: true,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.chevron_right,
                size: 28,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
