import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_ease/models/service_provider.dart';

class ProviderService {
  static Future<List<ServiceProvider>> getProvidersByService(
    String serviceName,
  ) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("service_providers")
        .where("services", arrayContains: serviceName)
        .get();

    final providers = snapshot.docs
        .map((doc) => ServiceProvider.fromMap(doc.data()))
        .toList();

    providers.sort((a, b) => b.rating.compareTo(a.rating));

    return providers;
  }

  static Future<List<ServiceProvider>> getTopProviders() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("service_providers")
        .get();

    final providers = snapshot.docs
        .map((doc) => ServiceProvider.fromMap(doc.data()))
        .toList();

    providers.sort((a, b) => b.rating.compareTo(a.rating));

    return providers.take(6).toList();
  }
}
