import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_ease/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderBookingsScreen extends StatefulWidget {
  const ProviderBookingsScreen({super.key});

  @override
  State<ProviderBookingsScreen> createState() => _ProviderBookingsScreenState();
}

class _ProviderBookingsScreenState extends State<ProviderBookingsScreen> {
  bool isLoading = true;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> bookings = [];

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        return;
      }

      final providerDocument = await FirebaseFirestore.instance
          .collection("serviceProviders")
          .doc(user.uid)
          .get();

      if (!providerDocument.exists) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        return;
      }

      final employeeCode = providerDocument.data()?["employeeCode"] ?? "";

      final snapshot = await FirebaseFirestore.instance
          .collection("bookings")
          .where("providerId", isEqualTo: employeeCode)
          .orderBy("createdAt", descending: true)
          .get();

      if (!mounted) return;

      setState(() {
        bookings = snapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Provider bookings error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateBookingStatus(
    QueryDocumentSnapshot<Map<String, dynamic>> booking,
    String status,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("bookings")
          .doc(booking.id)
          .update({"status": status});

      await loadBookings();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == "Accepted"
                ? "Booking accepted successfully."
                : "Booking rejected successfully.",
          ),
        ),
      );
    } catch (e) {
      debugPrint("Booking status update error: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to update booking.")),
      );
    }
  }

  Future<void> logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
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
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    await FirebaseAuth.instance.signOut();
  }

  Future<void> changeTheme(bool value) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString("themeMode", value ? "dark" : "light");

    HomeEaseApp.themeMode.value = value ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode_outlined, size: 20),
              Switch(value: isDark, onChanged: changeTheme),
            ],
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
          ? const Center(
              child: Text("No bookings found.", style: TextStyle(fontSize: 16)),
            )
          : RefreshIndicator(
              onRefresh: loadBookings,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final data = booking.data();

                  final serviceName = data["serviceName"] ?? "Home Service";

                  final userId = data["userId"] ?? "";

                  final date = data["date"] ?? "";

                  final timeSlot = data["timeSlot"] ?? "";

                  final charges = data["chargesPerHour"] ?? 0;

                  final status = data["status"] ?? "Pending";

                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceName,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text("Customer ID: $userId"),

                          Text("Date: $date"),

                          Text("Time: $timeSlot"),

                          Text("Charges: ₹$charges/hour"),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: status == "Accepted"
                                  ? Colors.green.shade100
                                  : status == "Rejected"
                                  ? Colors.red.shade100
                                  : status == "Cancelled"
                                  ? Colors.red.shade100
                                  : Colors.orange.shade100,
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

                          if (status == "Pending") ...[
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      updateBookingStatus(booking, "Accepted");
                                    },
                                    icon: const Icon(Icons.check),
                                    label: const Text("Accept"),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      updateBookingStatus(booking, "Rejected");
                                    },
                                    icon: const Icon(Icons.close),
                                    label: const Text("Reject"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
