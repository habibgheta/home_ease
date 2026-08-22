import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_ease/models/service_provider.dart';
import 'package:home_ease/models/booking.dart';
import 'package:home_ease/services/booking_service.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({
    super.key,
    required this.provider,
    required this.serviceName,
  });

  final ServiceProvider provider;
  final String serviceName;

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  String selectedDate = "";

  String selectedTime = "9:00 AM - 10:00 AM";

  bool isLoading = false;

  bool isSlotBooked = false;
  bool isBookedByCurrentUser = false;

  bool isCheckingSlot = false;

  final List<String> timeSlots = [
    "9:00 AM - 10:00 AM",
    "10:00 AM - 11:00 AM",
    "11:00 AM - 12:00 PM",
    "12:00 PM - 1:00 PM",
    "2:00 PM - 3:00 PM",
    "3:00 PM - 4:00 PM",
    "4:00 PM - 5:00 PM",
    "5:00 PM - 6:00 PM",
  ];

  @override
  void initState() {
    super.initState();

    final tomorrow = DateTime.now().add(const Duration(days: 1));

    selectedDate = _formatDate(tomorrow);

    checkSlotAvailability();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, "0");
    final month = date.month.toString().padLeft(2, "0");
    final year = date.year.toString();

    return "$year-$month-$day";
  }

  Future<void> checkSlotAvailability() async {
    if (!mounted) return;

    setState(() {
      isCheckingSlot = true;
      isSlotBooked = false;
      isBookedByCurrentUser = false;
    });

    try {
      final bookingUserId = await BookingService.getSlotBookingUserId(
        providerId: widget.provider.employeeCode,
        date: selectedDate,
        timeSlot: selectedTime,
      );

      final currentUser = FirebaseAuth.instance.currentUser;

      final booked = bookingUserId != null;
      final bookedByCurrentUser = booked && bookingUserId == currentUser?.uid;

      if (!mounted) return;

      setState(() {
        isSlotBooked = booked;
        isBookedByCurrentUser = bookedByCurrentUser;
        isCheckingSlot = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isCheckingSlot = false;
      });

      debugPrint("Slot availability error: $e");
    }
  }

  Future<void> selectDate() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      initialDate: DateTime.parse(selectedDate),
    );

    if (pickedDate == null) return;

    setState(() {
      selectedDate = _formatDate(pickedDate);
    });

    await checkSlotAvailability();
  }

  Future<void> selectTimeSlot(String value) async {
    setState(() {
      selectedTime = value;
    });

    await checkSlotAvailability();
  }

  Future<void> bookService() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to book a service.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final alreadyBooked = await BookingService.isSlotBooked(
        providerId: widget.provider.employeeCode,
        date: selectedDate,
        timeSlot: selectedTime,
      );

      if (alreadyBooked) {
        if (!mounted) return;

        setState(() {
          isSlotBooked = true;
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Sorry, this service provider is already booked "
              "for this time slot.",
            ),
          ),
        );

        return;
      }

      final bookingId = BookingService.createBookingId(
        providerId: widget.provider.employeeCode,
        date: selectedDate,
        timeSlot: selectedTime,
      );

      final booking = Booking(
        provider: widget.provider,
        serviceName: widget.serviceName,
        userId: user.uid,
        date: selectedDate,
        timeSlot: selectedTime,
        bookingId: bookingId,
        createdAt: DateTime.now(),
      );

      await BookingService.addBooking(booking);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Booking Successful")));

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to complete booking. Please try again."),
        ),
      );

      debugPrint("Booking error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Details")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
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
                    backgroundImage: widget.provider.imageUrl.isNotEmpty
                        ? NetworkImage(widget.provider.imageUrl)
                        : null,
                    child: widget.provider.imageUrl.isEmpty
                        ? const Icon(Icons.person, size: 45)
                        : null,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    widget.provider.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Employee ID: ${widget.provider.employeeCode}",
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.serviceName,
                    style: const TextStyle(fontSize: 17, color: Colors.grey),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    widget.provider.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
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
                        "₹${widget.provider.chargesPerHour}/hour",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Select Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            InkWell(
              onTap: isLoading ? null : selectDate,

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(selectedDate),

                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Select Time Slot",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            DropdownButton<String>(
              value: selectedTime,

              isExpanded: true,

              items: timeSlots.map((time) {
                return DropdownMenuItem<String>(value: time, child: Text(time));
              }).toList(),

              onChanged: isLoading
                  ? null
                  : (value) {
                      if (value == null) return;

                      selectTimeSlot(value);
                    },
            ),

            if (!isCheckingSlot && isSlotBooked)
              Padding(
                padding: const EdgeInsets.only(top: 8),

                child: Text(
                  isBookedByCurrentUser
                      ? "You have already booked this service provider for this time slot."
                      : "Sorry, this service provider is already booked for this time slot.",

                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: isLoading || isCheckingSlot || isSlotBooked
                    ? null
                    : bookService,

                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,

                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isSlotBooked ? "Time Slot Unavailable" : "Book Now"),
              ),
            ),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
