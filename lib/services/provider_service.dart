import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_ease/models/service_provider.dart';

class ProviderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<ServiceProvider>> getAllProviders() async {
    final snapshot = await _firestore.collection("serviceProviders").get();

    return snapshot.docs
        .map((document) => ServiceProvider.fromMap(document.data()))
        .toList();
  }

  static Future<List<ServiceProvider>> getTopProviders() async {
    final snapshot = await _firestore.collection("serviceProviders").get();

    return snapshot.docs
        .map((document) => ServiceProvider.fromMap(document.data()))
        .toList();
  }

  static Future<List<ServiceProvider>> getProvidersByService(
    String serviceName,
  ) async {
    final snapshot = await _firestore
        .collection("serviceProviders")
        .where("services", arrayContains: serviceName)
        .get();

    return snapshot.docs
        .map((document) => ServiceProvider.fromMap(document.data()))
        .toList();
  }

  static Future<ServiceProvider?> getProviderByUid(String uid) async {
    final document = await _firestore
        .collection("serviceProviders")
        .doc(uid)
        .get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return ServiceProvider.fromMap(document.data()!);
  }

  static Future<void> addProvider(ServiceProvider provider) async {
    await _firestore
        .collection("serviceProviders")
        .doc(provider.uid)
        .set(provider.toMap());
  }

  static Future<void> updateProvider(ServiceProvider provider) async {
    await _firestore
        .collection("serviceProviders")
        .doc(provider.uid)
        .update(provider.toMap());
  }

  static Future<void> deleteProvider(String providerId) async {
    await _firestore.collection("serviceProviders").doc(providerId).delete();
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getProviderBookings(String employeeCode) async {
    final snapshot = await _firestore
        .collection("bookings")
        .where("providerId", isEqualTo: employeeCode)
        .get();

    return snapshot.docs;
  }

  static Future<void> updateBookingStatus(
    String bookingId,
    String status,
  ) async {
    await _firestore.collection("bookings").doc(bookingId).update({
      "status": status,
    });
  }
}
