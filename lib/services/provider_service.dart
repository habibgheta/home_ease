import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_ease/models/service_provider.dart';

class ProviderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> get _providersCollection =>
      _firestore.collection("service_providers");

  static Future<List<ServiceProvider>> getProvidersByService(
    String serviceName,
  ) async {
    final snapshot = await _providersCollection
        .where("services", arrayContains: serviceName)
        .get();

    final providers = snapshot.docs
        .map((doc) => ServiceProvider.fromMap(doc.data()))
        .toList();

    providers.sort((a, b) => b.rating.compareTo(a.rating));

    return providers;
  }

  static Future<List<ServiceProvider>> getTopProviders() async {
    final snapshot = await _providersCollection.get();

    final providers = snapshot.docs
        .map((doc) => ServiceProvider.fromMap(doc.data()))
        .toList();

    providers.sort((a, b) => b.rating.compareTo(a.rating));

    return providers.take(6).toList();
  }

  static Future<List<ServiceProvider>> getAllProviders() async {
    final snapshot = await _providersCollection.get();

    return snapshot.docs.map((doc) {
      return ServiceProvider.fromMap(doc.data());
    }).toList();
  }

  static Future<void> addProvider(ServiceProvider provider) async {
    await _providersCollection.doc(provider.employeeCode).set(provider.toMap());
  }

  static Future<void> updateProvider(ServiceProvider provider) async {
    await _providersCollection
        .doc(provider.employeeCode)
        .update(provider.toMap());
  }

  static Future<void> deleteProvider(String employeeCode) async {
    await _providersCollection.doc(employeeCode).delete();
  }
}
