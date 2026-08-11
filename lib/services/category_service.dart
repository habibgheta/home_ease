import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_ease/models/service_category.dart';

class CategoryService {
  static Future<List<ServiceCategory>> getCategories() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("service_categories")
        .orderBy("displayOrder")
        .get();

    return snapshot.docs
        .map((doc) => ServiceCategory.fromMap(doc.data()))
        .where((category) => category.isActive)
        .toList();
  }
}
