import 'package:home_ease/models/favorite.dart';
import 'package:home_ease/models/service_provider.dart';

class FavoriteService {
  static final List<Favorite> favorites = [];

  static void addFavorite(ServiceProvider provider) {
    if (!isFavorite(provider)) {
      favorites.add(Favorite(provider: provider));
    }
  }

  static void removeFavorite(ServiceProvider provider) {
    favorites.removeWhere(
      (favorite) => favorite.provider.name == provider.name,
    );
  }

  static bool isFavorite(ServiceProvider provider) {
    return favorites.any((favorite) => favorite.provider.name == provider.name);
  }

  static List<Favorite> getFavorites() {
    return favorites;
  }
}
