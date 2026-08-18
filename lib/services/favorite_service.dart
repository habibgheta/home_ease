import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_ease/models/service_provider.dart';

class FavoriteService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> _favoritesCollection() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User is not logged in.");
    }

    return _firestore.collection("users").doc(user.uid).collection("favorites");
  }

  static Future<void> addFavorite(ServiceProvider provider) async {
    await _favoritesCollection()
        .doc(provider.employeeCode)
        .set(provider.toMap());
  }

  static Future<void> removeFavorite(ServiceProvider provider) async {
    await _favoritesCollection().doc(provider.employeeCode).delete();
  }

  static Future<bool> isFavorite(ServiceProvider provider) async {
    final document = await _favoritesCollection()
        .doc(provider.employeeCode)
        .get();

    return document.exists;
  }

  static Future<List<ServiceProvider>> getFavorites() async {
    final snapshot = await _favoritesCollection().get();

    return snapshot.docs.map((document) {
      return ServiceProvider.fromMap(document.data());
    }).toList();
  }
}
