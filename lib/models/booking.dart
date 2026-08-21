import 'package:home_ease/models/service_provider.dart';

class Booking {
  final ServiceProvider provider;
  final String serviceName;
  final String userId;
  final String date;
  final String timeSlot;
  final String status;
  final String bookingId;
  final DateTime createdAt;

  Booking({
    required this.provider,
    required this.serviceName,
    required this.userId,
    required this.date,
    required this.timeSlot,
    this.status = "Pending",
    required this.bookingId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "bookingId": bookingId,
      "userId": userId,
      "providerId": provider.employeeCode,
      "providerName": provider.name,
      "serviceName": serviceName,
      "providerServices": provider.services,
      "providerDescription": provider.description,
      "providerStatus": provider.status,
      "providerRating": provider.rating,
      "providerReviews": provider.reviews,
      "chargesPerHour": provider.chargesPerHour,
      "imageUrl": provider.imageUrl,
      "date": date,
      "timeSlot": timeSlot,
      "status": status,
      "createdAt": createdAt,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    final provider = ServiceProvider(
      employeeCode: map["providerId"] ?? "",
      name: map["providerName"] ?? "",
      services: List<String>.from(map["providerServices"] ?? []),
      description: map["providerDescription"] ?? "",
      status: map["providerStatus"] ?? "Available",
      rating: (map["providerRating"] ?? 0).toDouble(),
      reviews: map["providerReviews"] ?? 0,
      chargesPerHour: map["chargesPerHour"] ?? 0,
      imageUrl: map["imageUrl"] ?? "",
    );

    return Booking(
      provider: provider,
      serviceName: map["serviceName"] ?? "",
      userId: map["userId"] ?? "",
      date: map["date"] ?? "",
      timeSlot: map["timeSlot"] ?? "",
      status: map["status"] ?? "Pending",
      bookingId: map["bookingId"] ?? "",
      createdAt: map["createdAt"]?.toDate() ?? DateTime.now(),
    );
  }
}
