import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_ease/models/booking.dart';

class BookingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final CollectionReference<Map<String, dynamic>> _bookingsCollection =
      _firestore.collection("bookings");

  static String createBookingId({
    required String providerId,
    required String date,
    required String timeSlot,
  }) {
    final cleanProviderId = providerId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

    final cleanDate = date.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

    final cleanTime = timeSlot.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

    return "${cleanProviderId}_${cleanDate}_$cleanTime";
  }

  static Future<bool> isSlotBooked({
    required String providerId,
    required String date,
    required String timeSlot,
  }) async {
    final bookingId = createBookingId(
      providerId: providerId,
      date: date,
      timeSlot: timeSlot,
    );

    final document = await _bookingsCollection.doc(bookingId).get();

    if (!document.exists) {
      return false;
    }

    final data = document.data();

    final status = data?["status"];

    return status == "Pending" || status == "Accepted";
  }

  static Future<void> addBooking(Booking booking) async {
    await _bookingsCollection.doc(booking.bookingId).set(booking.toMap());
  }

  static Future<List<Booking>> getBookings(String userId) async {
    final snapshot = await _bookingsCollection
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs
        .map((document) => Booking.fromMap(document.data()))
        .toList();
  }

  static Future<void> cancelBooking(String bookingId) async {
    await _bookingsCollection.doc(bookingId).update({"status": "Cancelled"});
  }

  static Future<String?> getSlotBookingUserId({
    required String providerId,
    required String date,
    required String timeSlot,
  }) async {
    final bookingId = createBookingId(
      providerId: providerId,
      date: date,
      timeSlot: timeSlot,
    );

    final document = await _bookingsCollection.doc(bookingId).get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    final status = data?["status"];

    if (status != "Pending" && status != "Accepted") {
      return null;
    }

    return data?["userId"] as String?;
  }
}
