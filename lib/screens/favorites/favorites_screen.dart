import 'package:flutter/material.dart';
import 'package:home_ease/models/service_provider.dart';
import 'package:home_ease/services/favorite_service.dart';
import 'package:home_ease/widgets/provider_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<ServiceProvider> favorites = [];

  bool isLoading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final result = await FavoriteService.getFavorites();

      if (!mounted) return;

      setState(() {
        favorites = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = "Unable to load favorite providers.";
      });

      debugPrint("Favorites loading error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Providers")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: const TextStyle(fontSize: 16)),
      );
    }

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
        return ProviderCard(provider: favorites[index], onTap: () {});
      },
    );
  }
}
