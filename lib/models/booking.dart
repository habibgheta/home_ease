import 'package:home_ease/models/service_provider.dart';

class Booking {
  final ServiceProvider provider;
  final String date;
  final String timeSlot;
  final String status;
  final String bookingId;

  Booking({
    required this.provider,
    required this.date,
    required this.timeSlot,
    this.status = "Booked",
    required this.bookingId,
  });
}
