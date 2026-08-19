import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:home_ease/models/app_user.dart';
import 'package:home_ease/services/cloudinary_service.dart';
import 'package:home_ease/services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.user});

  final AppUser user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;

  XFile? selectedImage;
  Uint8List? selectedImageBytes;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController(text: widget.user.firstName);

    lastNameController = TextEditingController(text: widget.user.lastName);

    emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();

    super.dispose();
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final bytes = await image.readAsBytes();

    if (!mounted) return;

    setState(() {
      selectedImage = image;
      selectedImageBytes = bytes;
    });
  }

  Future<void> saveProfile() async {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("First name and last name are required.")),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      String photoUrl = widget.user.photoUrl;

      if (selectedImage != null) {
        final uploadedUrl = await CloudinaryService.uploadImage(selectedImage!);

        if (uploadedUrl == null) {
          throw Exception("Image upload failed.");
        }

        photoUrl = uploadedUrl;
      }

      await UserService.updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        photoUrl: photoUrl,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully.")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to update profile. Please try again."),
        ),
      );

      debugPrint("Profile update error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasNewImage = selectedImageBytes != null;
    final hasExistingImage = widget.user.photoUrl.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: isSaving ? null : pickProfileImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: hasNewImage
                        ? MemoryImage(selectedImageBytes!)
                        : hasExistingImage
                        ? NetworkImage(widget.user.photoUrl)
                        : null,
                    child: !hasNewImage && !hasExistingImage
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),

                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 19,
                      child: const Icon(Icons.camera_alt, size: 19),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Tap to change profile picture",
              style: TextStyle(color: Colors.blueGrey),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              readOnly: true,
              style: const TextStyle(color: Colors.blueGrey),
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFE8EAF6),
              ),
            ),

            const SizedBox(height: 8),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email cannot be changed.",
                style: TextStyle(color: Colors.blueGrey, fontSize: 13),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: firstNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "First Name",
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: lastNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Last Name",
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveProfile,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
