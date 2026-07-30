import 'package:home_ease/models/booking.dart';

class BookingService {
  static final List<Booking> bookings = [];

  static void addBooking(Booking booking) {
    bookings.add(booking);
  }

  static List<Booking> getBookings() {
    return bookings;
  }

  static bool isSlotBooked({
    required String providerName,
    required String date,
    required String timeSlot,
  }) {
    return bookings.any(
      (booking) =>
          booking.provider.name == providerName &&
          booking.date == date &&
          booking.timeSlot == timeSlot,
    );
  }
}
