import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_ease/models/service_category.dart';

class CategoryService {
  static final CollectionReference<Map<String, dynamic>> _categoriesCollection =
      FirebaseFirestore.instance.collection("service_categories");

  static Future<List<ServiceCategory>> getCategories() async {
    final snapshot = await _categoriesCollection.orderBy("displayOrder").get();

    return snapshot.docs
        .map((doc) => ServiceCategory.fromMap(doc.data()))
        .where((category) => category.isActive)
        .toList();
  }

  static Future<List<ServiceCategory>> getAllCategories() async {
    final snapshot = await _categoriesCollection.orderBy("displayOrder").get();

    return snapshot.docs
        .map((doc) => ServiceCategory.fromMap(doc.data()))
        .toList();
  }

  static Future<void> addCategory(ServiceCategory category) async {
    await _categoriesCollection.doc(category.name).set(category.toMap());
  }

  static Future<void> updateCategory(ServiceCategory category) async {
    await _categoriesCollection.doc(category.name).update(category.toMap());
  }

  static Future<void> deleteCategory(String name) async {
    await _categoriesCollection.doc(name).delete();
  }
}
