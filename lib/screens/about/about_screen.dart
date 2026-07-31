import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> openLinkedIn() async {
    final Uri url = Uri.parse("https://www.linkedin.com/in/habibgheta");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> sendEmail() async {
    final Uri email = Uri(
      scheme: "mailto",
      path: "ghetahabib@gmail.com",
      query: "subject=HomeEase Support",
    );

    if (await canLaunchUrl(email)) {
      await launchUrl(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset("assets/images/home_ease_logo.png", height: 170),
                  const SizedBox(height: 15),
                  const Text(
                    "HomeEase",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Version 1.0.0",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "About HomeEase",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text(
              "HomeEase is a home service booking application designed to help users connect with trusted professionals such as electricians, plumbers, carpenters, painters and cleaners. The application allows users to browse available services, book appointments, manage bookings and save their favourite service providers through a simple and user-friendly interface.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6),
            ),

            const SizedBox(height: 30),

            const Divider(),

            const SizedBox(height: 10),

            const Text(
              "Contact Us",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email, color: Colors.red),
              title: const Text("Email"),
              subtitle: const Text("ghetahabib@gmail.com"),
              trailing: const Icon(Icons.open_in_new),
              onTap: sendEmail,
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language, color: Colors.green),
              title: const Text("Website"),
              subtitle: const Text("www.homeease.com"),
              trailing: const Icon(Icons.open_in_new),
            ),

            const Divider(),

            const SizedBox(height: 10),

            const Text(
              "Connect With Us",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.business, color: Colors.blue),
              title: const Text("LinkedIn"),
              subtitle: const Text("linkedin.com/in/habibgheta"),
              trailing: const Icon(Icons.open_in_new),
              onTap: openLinkedIn,
            ),

            const Divider(),

            const SizedBox(height: 20),

            Center(
              child: Column(
                children: const [
                  Text(
                    "Developed By",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Habib Gheta",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
