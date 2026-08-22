import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:home_ease/models/service_provider.dart';
import 'package:home_ease/services/provider_service.dart';
import 'package:home_ease/services/cloudinary_service.dart';

class AdminProvidersScreen extends StatefulWidget {
  const AdminProvidersScreen({super.key});

  @override
  State<AdminProvidersScreen> createState() => _AdminProvidersScreenState();
}

class _AdminProvidersScreenState extends State<AdminProvidersScreen> {
  List<ServiceProvider> providers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProviders();
  }

  Future<void> loadProviders() async {
    try {
      final result = await ProviderService.getAllProviders();

      if (!mounted) return;

      setState(() {
        providers = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      debugPrint("Admin provider loading error: $e");
    }
  }

  Future<void> deleteProvider(ServiceProvider provider) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Provider"),
          content: Text("Are you sure you want to delete ${provider.name}?"),
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
      await ProviderService.deleteProvider(provider.employeeCode);

      if (!mounted) return;

      await loadProviders();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Provider deleted successfully.")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to delete provider.")),
      );
    }
  }

  Future<void> openProviderForm({ServiceProvider? provider}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AdminProviderFormScreen(provider: provider),
      ),
    );

    if (result == true) {
      loadProviders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Providers")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openProviderForm();
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : providers.isEmpty
          ? const Center(
              child: Text(
                "No service providers found.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: providers.length,
              itemBuilder: (context, index) {
                final provider = providers[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: provider.imageUrl.isNotEmpty
                          ? NetworkImage(provider.imageUrl)
                          : null,
                      child: provider.imageUrl.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      provider.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${provider.employeeCode}\n"
                      "${provider.services.join(", ")}\n"
                      "${provider.status} • "
                      "₹${provider.chargesPerHour}/hr",
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "edit") {
                          openProviderForm(provider: provider);
                        } else if (value == "delete") {
                          deleteProvider(provider);
                        }
                      },
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(value: "edit", child: Text("Edit")),
                          PopupMenuItem(value: "delete", child: Text("Delete")),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class AdminProviderFormScreen extends StatefulWidget {
  const AdminProviderFormScreen({super.key, this.provider});

  final ServiceProvider? provider;

  @override
  State<AdminProviderFormScreen> createState() =>
      _AdminProviderFormScreenState();
}

class _AdminProviderFormScreenState extends State<AdminProviderFormScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController employeeCodeController;
  late final TextEditingController nameController;
  late final TextEditingController servicesController;
  late final TextEditingController descriptionController;
  late final TextEditingController ratingController;
  late final TextEditingController reviewsController;
  late final TextEditingController chargesController;

  String status = "Available";

  bool isSaving = false;

  XFile? selectedImage;

  String imageUrl = "";

  bool get isEditing => widget.provider != null;

  @override
  void initState() {
    super.initState();

    final provider = widget.provider;

    employeeCodeController = TextEditingController(
      text: provider?.employeeCode ?? "",
    );

    nameController = TextEditingController(text: provider?.name ?? "");

    servicesController = TextEditingController(
      text: provider?.services.join(", ") ?? "",
    );

    descriptionController = TextEditingController(
      text: provider?.description ?? "",
    );

    ratingController = TextEditingController(
      text: provider?.rating.toString() ?? "0",
    );

    reviewsController = TextEditingController(
      text: provider?.reviews.toString() ?? "0",
    );

    chargesController = TextEditingController(
      text: provider?.chargesPerHour.toString() ?? "",
    );

    status = provider?.status ?? "Available";

    imageUrl = provider?.imageUrl ?? "";
  }

  @override
  void dispose() {
    employeeCodeController.dispose();
    nameController.dispose();
    servicesController.dispose();
    descriptionController.dispose();
    ratingController.dispose();
    reviewsController.dispose();
    chargesController.dispose();

    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      selectedImage = image;
    });
  }

  Future<String?> uploadSelectedImage() async {
    if (selectedImage == null) {
      return imageUrl;
    }

    return await CloudinaryService.uploadImage(selectedImage!);
  }

  Future<void> saveProvider() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final services = servicesController.text
          .split(",")
          .map((service) => service.trim())
          .where((service) => service.isNotEmpty)
          .toList();

      final uploadedImageUrl = await uploadSelectedImage();

      if (selectedImage != null && uploadedImageUrl == null) {
        if (!mounted) return;

        setState(() {
          isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image upload failed. Please try again."),
          ),
        );

        return;
      }

      final provider = ServiceProvider(
        employeeCode: employeeCodeController.text.trim(),
        name: nameController.text.trim(),
        services: services,
        description: descriptionController.text.trim(),
        status: status,
        rating: double.parse(ratingController.text.trim()),
        reviews: int.parse(reviewsController.text.trim()),
        chargesPerHour: int.parse(chargesController.text.trim()),
        imageUrl: uploadedImageUrl ?? "",
      );

      if (isEditing) {
        await ProviderService.updateProvider(provider);
      } else {
        await ProviderService.addProvider(provider);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to save provider. Please try again."),
        ),
      );

      debugPrint("Provider save error: $e");
    }
  }

  String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }

    return null;
  }

  String? numberField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }

    if (int.tryParse(value.trim()) == null) {
      return "Enter a valid number";
    }

    return null;
  }

  String? ratingField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }

    final rating = double.tryParse(value.trim());

    if (rating == null || rating < 0 || rating > 5) {
      return "Rating must be between 0 and 5";
    }

    return null;
  }

  Widget buildImagePreview() {
    if (selectedImage != null) {
      return FutureBuilder(
        future: selectedImage!.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
              radius: 55,
              backgroundImage: MemoryImage(snapshot.data!),
            );
          }

          return const CircleAvatar(
            radius: 55,
            child: CircularProgressIndicator(),
          );
        },
      );
    }

    if (imageUrl.isNotEmpty) {
      return CircleAvatar(radius: 55, backgroundImage: NetworkImage(imageUrl));
    }

    return const CircleAvatar(radius: 55, child: Icon(Icons.person, size: 55));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Provider" : "Add Provider")),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  buildImagePreview(),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: isSaving ? null : pickImage,
                    icon: const Icon(Icons.image),
                    label: Text(
                      selectedImage == null ? "Choose Image" : "Change Image",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: employeeCodeController,
              enabled: !isEditing,
              decoration: const InputDecoration(
                labelText: "Employee Code",
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: servicesController,
              decoration: const InputDecoration(
                labelText: "Services",
                hintText: "Electrician, Plumber",
                helperText: "Separate multiple services with commas",
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: status,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Available", child: Text("Available")),
                DropdownMenuItem(
                  value: "Not Available",
                  child: Text("Not Available"),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  status = value;
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: ratingController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: "Rating",
                border: OutlineInputBorder(),
              ),
              validator: ratingField,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: reviewsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Reviews",
                border: OutlineInputBorder(),
              ),
              validator: numberField,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: chargesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Charges Per Hour",
                prefixText: "₹",
                border: OutlineInputBorder(),
              ),
              validator: numberField,
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveProvider,
                child: isSaving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEditing ? "Update Provider" : "Add Provider"),
              ),
            ),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
