import 'package:flutter/material.dart';
import 'package:home_ease/models/service_provider.dart';
import 'package:home_ease/models/booking.dart';
import 'package:home_ease/services/booking_service.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key, required this.provider});

  final ServiceProvider provider;

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  String selectedDate = "Today";

  final List<String> dates = ["Today", "Tomorrow", "25 July", "26 July"];

  String selectedTime = "9:00 AM - 11:00 AM";

  final List<String> timeSlots = [
    "9:00 AM - 11:00 AM",
    "11:00 AM - 1:00 PM",
    "2:00 PM - 4:00 PM",
    "4:00 PM - 6:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(widget.provider.image),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    widget.provider.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.provider.service,
                    style: const TextStyle(fontSize: 17, color: Colors.grey),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "⭐ ${widget.provider.rating}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "₹${widget.provider.charges}/hour",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Row(
              children: [
                Text(
                  "Select Date",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            DropdownButton<String>(
              value: selectedDate,
              isExpanded: true,
              items: dates.map((date) {
                return DropdownMenuItem<String>(value: date, child: Text(date));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDate = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Row(
              children: [
                Text(
                  "Select Time Slot",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            DropdownButton<String>(
              value: selectedTime,
              isExpanded: true,
              items: timeSlots.map((time) {
                return DropdownMenuItem<String>(value: time, child: Text(time));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTime = value!;
                });
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (BookingService.isSlotBooked(
                    providerName: widget.provider.name,
                    date: selectedDate,
                    timeSlot: selectedTime,
                  )) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "This time slot is already booked. Please choose another slot.",
                        ),
                      ),
                    );
                    return;
                  }

                  Booking booking = Booking(
                    provider: widget.provider,
                    date: selectedDate,
                    timeSlot: selectedTime,
                    bookingId: DateTime.now().millisecondsSinceEpoch.toString(),
                  );

                  BookingService.addBooking(booking);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Booking Successful")),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Book Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
