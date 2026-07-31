import 'package:flutter/material.dart';
import 'package:home_ease/services/favorite_service.dart';
import 'package:home_ease/widgets/provider_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Providers")),
      body: Builder(
        builder: (context) {
          final favorites = FavoriteService.getFavorites();

          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                "No Favorite Providers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return ProviderCard(provider: favorites[index].provider);
            },
          );
        },
      ),
    );
  }
}
