import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> bookings = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      final snapshot = await _firestore.collection("bookings").get();

      if (!mounted) return;

      setState(() {
        bookings = snapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      debugPrint("Admin booking loading error: $e");
    }
  }

  Future<void> updateBookingStatus(
    QueryDocumentSnapshot<Map<String, dynamic>> booking,
    String status,
  ) async {
    try {
      await _firestore.collection("bookings").doc(booking.id).update({
        "status": status,
      });

      if (!mounted) return;

      await loadBookings();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Booking marked as $status.")));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to update booking.")),
      );

      debugPrint("Booking status update error: $e");
    }
  }

  Future<void> deleteBooking(
    QueryDocumentSnapshot<Map<String, dynamic>> booking,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Booking"),
          content: const Text("Are you sure you want to delete this booking?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    try {
      await _firestore.collection("bookings").doc(booking.id).delete();

      if (!mounted) return;

      await loadBookings();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking deleted successfully.")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to delete booking.")),
      );

      debugPrint("Booking delete error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookings")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
          ? const Center(
              child: Text("No bookings found.", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final data = booking.data();

                final providerName = data["providerName"] ?? "Unknown Provider";

                final providerId = data["providerId"] ?? "";

                final serviceName = data["serviceName"] ?? "";

                final userId = data["userId"] ?? "";

                final date = data["date"] ?? "";

                final timeSlot = data["timeSlot"] ?? "";

                final status = data["status"] ?? "Booked";

                final charges = data["chargesPerHour"] ?? 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                providerName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == "cancel") {
                                  updateBookingStatus(booking, "Cancelled");
                                } else if (value == "delete") {
                                  deleteBooking(booking);
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  if (status != "Cancelled")
                                    const PopupMenuItem(
                                      value: "cancel",
                                      child: Text("Cancel Booking"),
                                    ),
                                  const PopupMenuItem(
                                    value: "delete",
                                    child: Text("Delete Booking"),
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text("Provider ID: $providerId"),
                        Text("Service: $serviceName"),

                        const SizedBox(height: 4),

                        Text("User ID: $userId"),

                        const SizedBox(height: 8),

                        Text("Date: $date"),
                        Text("Time: $timeSlot"),
                        Text("Charges: ₹$charges/hour"),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: status == "Cancelled"
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: Colors.black,
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
