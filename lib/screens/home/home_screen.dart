import 'package:flutter/material.dart';
import 'package:home_ease/models/service_category.dart';
import 'package:home_ease/widgets/service_card.dart';
import 'package:home_ease/widgets/provider_card.dart';
import 'package:home_ease/screens/home/service_providers_screen.dart';
import 'package:home_ease/screens/main_screen.dart';
import 'package:home_ease/screens/booking/bookings_screen.dart';
import 'package:home_ease/screens/favorites/favorites_screen.dart';
import 'package:home_ease/screens/settings/settings_screen.dart';
import 'package:home_ease/screens/about/about_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_ease/models/app_user.dart';
import 'package:home_ease/services/user_service.dart';
import 'package:home_ease/services/category_service.dart';
import 'package:home_ease/services/provider_service.dart';
import 'package:home_ease/screens/booking/booking_details_screen.dart';
import 'package:home_ease/models/service_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppUser? currentUser;

  bool isLoading = true;

  List<ServiceCategory> serviceCategories = [];

  List<ServiceProvider> topProviders = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    final user = await UserService.getCurrentUser();
    final categories = await CategoryService.getCategories();
    final providers = await ProviderService.getTopProviders();

    if (!mounted) return;

    setState(() {
      currentUser = user;
      serviceCategories = categories;
      topProviders = providers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("HomeEase"), centerTitle: true),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "${currentUser?.firstName ?? ""} ${currentUser?.lastName ?? ""}",
              ),
              accountEmail: Text(currentUser?.email ?? ""),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Image(
                    image: AssetImage("assets/images/home_ease_logo.png"),
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("My Bookings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookingsScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About Us"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            await FirebaseAuth.instance.signOut();

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Logged out successfully"),
                              ),
                            );
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, ${currentUser?.firstName ?? "User"} 👋",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "Find the service you need today.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),

              const SizedBox(height: 24),

              TextField(
                decoration: InputDecoration(
                  hintText: "Search services...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Services",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: serviceCategories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 120,
                      child: ServiceCard(
                        category: serviceCategories[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceProvidersScreen(
                                serviceName: serviceCategories[index].name,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Top Professionals",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("View All")),
                ],
              ),

              const SizedBox(height: 16),

              if (topProviders.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text("No professionals available")),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: topProviders.length,
                  itemBuilder: (context, index) {
                    final provider = topProviders[index];

                    return ProviderCard(
                      provider: provider,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingDetailsScreen(
                              provider: provider,
                              serviceName: provider.services.isNotEmpty
                                  ? provider.services.first
                                  : "Home Service",
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
