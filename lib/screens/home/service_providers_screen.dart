import 'package:flutter/material.dart';
import 'package:home_ease/models/service_provider.dart';
import 'package:home_ease/services/provider_service.dart';
import 'package:home_ease/widgets/provider_card.dart';
import 'package:home_ease/screens/booking/booking_details_screen.dart';

class ServiceProvidersScreen extends StatefulWidget {
  const ServiceProvidersScreen({super.key, required this.serviceName});

  final String serviceName;

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  List<ServiceProvider> providers = [];

  bool isLoading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProviders();
  }

  Future<void> loadProviders() async {
    try {
      final result = await ProviderService.getProvidersByService(
        widget.serviceName,
      );

      if (!mounted) return;

      setState(() {
        providers = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = "Unable to load service providers.";
        isLoading = false;
      });

      debugPrint("Provider loading error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.serviceName)),

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

    if (providers.isEmpty) {
      return const Center(
        child: Text(
          "No service providers available.",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];

          return ProviderCard(
            provider: provider,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BookingDetailsScreen(provider: provider),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
