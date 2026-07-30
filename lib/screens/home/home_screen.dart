import 'package:flutter/material.dart';
import 'package:home_ease/models/service_category.dart';
import 'package:home_ease/widgets/service_card.dart';
import 'package:home_ease/models/service_provider.dart';
import 'package:home_ease/widgets/provider_card.dart';
import 'package:home_ease/screens/home/service_providers_screen.dart';
import 'package:home_ease/screens/main_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<ServiceCategory> _serviceCategories = [
    ServiceCategory(name: "Electrician", icon: Icons.electrical_services),
    ServiceCategory(name: "Plumber", icon: Icons.plumbing),
    ServiceCategory(name: "Carpenter", icon: Icons.handyman),
    ServiceCategory(name: "Painter", icon: Icons.format_paint),
    ServiceCategory(name: "Cleaner", icon: Icons.cleaning_services),
  ];

  static const List<ServiceProvider> _serviceProviders = [
    ServiceProvider(
      name: "Rahul Sharma",
      image: "assets/images/providers/provider1.jpg",
      service: "Electrician",
      rating: 4.8,
      reviews: 120,
      charges: 500,
    ),
    ServiceProvider(
      name: "Aditya Singh",
      image: "assets/images/providers/provider2.jpg",
      service: "Electrician",
      rating: 4.6,
      reviews: 96,
      charges: 450,
    ),
    ServiceProvider(
      name: "Amit Patel",
      image: "assets/images/providers/provider3.jpg",
      service: "Plumber",
      rating: 4.7,
      reviews: 98,
      charges: 450,
    ),
    ServiceProvider(
      name: "Vikram Shah",
      image: "assets/images/providers/provider4.jpg",
      service: "Plumber",
      rating: 4.9,
      reviews: 145,
      charges: 550,
    ),
    ServiceProvider(
      name: "Mohan Verma",
      image: "assets/images/providers/provider1.jpg",
      service: "Painter",
      rating: 4.9,
      reviews: 170,
      charges: 600,
    ),
    ServiceProvider(
      name: "Ramesh Gupta",
      image: "assets/images/providers/provider2.jpg",
      service: "Cleaner",
      rating: 4.6,
      reviews: 80,
      charges: 350,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HomeEase"), centerTitle: true),

      drawer: const Drawer(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello, Habib 👋",
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
                  itemCount: _serviceCategories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 120,
                      child: ServiceCard(
                        category: _serviceCategories[index],
                        onTap: () {
                          final selectedProviders = _serviceProviders
                              .where(
                                (provider) =>
                                    provider.service ==
                                    _serviceCategories[index].name,
                              )
                              .toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceProvidersScreen(
                                serviceName: _serviceCategories[index].name,
                                providers: selectedProviders,
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

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _serviceProviders.length,
                itemBuilder: (context, index) {
                  return ProviderCard(
                    provider: _serviceProviders[index],
                    onTap: () {},
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
