import 'package:flutter/material.dart';
import 'package:home_ease/services/booking_service.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = BookingService.getBookings();

    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: bookings.isEmpty
          ? const Center(
              child: Text(
                "No Bookings Yet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                booking.provider.image,
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.provider.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(booking.provider.service),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Text("Date : ${booking.date}"),

                        Text("Time : ${booking.timeSlot}"),

                        Text("Charges : ₹${booking.provider.charges}/hour"),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            booking.status,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
