import 'package:flutter/material.dart';
import 'package:home_ease/models/service_provider.dart';
import 'package:home_ease/widgets/provider_card.dart';
import 'package:home_ease/screens/booking/booking_details_screen.dart';

class ServiceProvidersScreen extends StatelessWidget {
  const ServiceProvidersScreen({
    super.key,
    required this.serviceName,
    required this.providers,
  });

  final String serviceName;
  final List<ServiceProvider> providers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serviceName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: providers.length,
          itemBuilder: (context, index) {
            return ProviderCard(
              provider: providers[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookingDetailsScreen(provider: providers[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
