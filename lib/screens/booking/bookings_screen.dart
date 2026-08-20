import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_ease/models/booking.dart';
import 'package:home_ease/services/booking_service.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<Booking> bookings = [];

  bool isLoading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        isLoading = false;
        errorMessage = "Please login to view your bookings.";
      });
      return;
    }

    try {
      final result = await BookingService.getBookings(user.uid);

      if (!mounted) return;

      setState(() {
        bookings = result;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = "Unable to load bookings.";
      });

      debugPrint("Booking loading error: $e");
    }
  }

  Future<void> cancelBooking(Booking booking) async {
    try {
      await BookingService.cancelBooking(booking.bookingId);

      if (!mounted) return;

      await loadBookings();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking cancelled successfully.")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to cancel booking. Please try again."),
        ),
      );

      debugPrint("Cancel booking error: $e");
    }
  }

  void showCancelConfirmation(Booking booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cancel Booking"),
          content: const Text("Are you sure you want to cancel this booking?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                cancelBooking(booking);
              },
              child: const Text("Yes, Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: const TextStyle(fontSize: 16)),
      );
    }

    if (bookings.isEmpty) {
      return const Center(
        child: Text(
          "No Bookings Yet",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        final isCancelled = booking.status == "Cancelled";

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
                      backgroundImage: booking.provider.imageUrl.isNotEmpty
                          ? NetworkImage(booking.provider.imageUrl)
                          : null,
                      child: booking.provider.imageUrl.isEmpty
                          ? const Icon(Icons.person)
                          : null,
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

                          Text(booking.serviceName),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Text("Date : ${booking.date}"),

                Text("Time : ${booking.timeSlot}"),

                Text("Charges : ₹${booking.provider.chargesPerHour}/hour"),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isCancelled ? Colors.red.shade100 : Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking.status,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (!isCancelled) ...[
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showCancelConfirmation(booking);
                      },
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text("Cancel Booking"),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
