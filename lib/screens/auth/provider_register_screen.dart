import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:home_ease/screens/auth/login_screen.dart';
import 'package:home_ease/services/cloudinary_service.dart';
import 'package:home_ease/widgets/custom_button.dart';
import 'package:home_ease/widgets/custom_text_field.dart';

class ProviderRegisterScreen extends StatefulWidget {
  const ProviderRegisterScreen({super.key});

  @override
  State<ProviderRegisterScreen> createState() => _ProviderRegisterScreenState();
}

class _ProviderRegisterScreenState extends State<ProviderRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final employeeCodeController = TextEditingController();
  final servicesController = TextEditingController();
  final descriptionController = TextEditingController();
  final chargesController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  Uint8List? selectedImageBytes;
  XFile? selectedImage;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    employeeCodeController.dispose();
    servicesController.dispose();
    descriptionController.dispose();
    chargesController.dispose();
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

  Future<void> registerProvider() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        isLoading = true;
      });

      final employeeCode = employeeCodeController.text.trim().toUpperCase();

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final user = userCredential.user;

      if (user == null) {
        throw Exception("Unable to create account.");
      }

      final existingProvider = await FirebaseFirestore.instance
          .collection("serviceProviders")
          .where("employeeCode", isEqualTo: employeeCode)
          .limit(1)
          .get();

      if (existingProvider.docs.isNotEmpty) {
        await user.delete();
        throw Exception("Employee code already exists.");
      }

      String photoUrl = "";

      if (selectedImage != null) {
        final uploadedUrl = await CloudinaryService.uploadImage(selectedImage!);

        if (uploadedUrl == null) {
          throw Exception("Image upload failed.");
        }

        photoUrl = uploadedUrl;
      }

      final services = servicesController.text
          .split(",")
          .map((service) => service.trim())
          .where((service) => service.isNotEmpty)
          .toList();

      await FirebaseFirestore.instance
          .collection("serviceProviders")
          .doc(user.uid)
          .set({
            "uid": user.uid,
            "employeeCode": employeeCode,
            "name":
                "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
            "services": services,
            "description": descriptionController.text.trim(),
            "status": "Available",
            "rating": 0.0,
            "reviews": 0,
            "chargesPerHour": int.parse(chargesController.text.trim()),
            "imageUrl": photoUrl,
            "email": emailController.text.trim(),
            "createdAt": FieldValue.serverTimestamp(),
          });

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Service provider account created successfully."),
        ),
      );

      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case "email-already-in-use":
          message = "An account already exists with this email.";
          break;

        case "invalid-email":
          message = "Please enter a valid email address.";
          break;

        case "weak-password":
          message = "Password is too weak.";
          break;

        case "network-request-failed":
          message = "Please check your internet connection.";
          break;

        default:
          message = e.message ?? "Registration failed.";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;

      String message = "Something went wrong.";

      if (e.toString().contains("Employee code already exists")) {
        message = "Employee code already exists.";
      } else if (e.toString().contains("Image upload failed")) {
        message = "Profile image upload failed.";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      debugPrint("Provider registration error: $e");
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
      appBar: AppBar(title: const Text("Service Provider Registration")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: isLoading ? null : pickProfileImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: selectedImageBytes != null
                            ? MemoryImage(selectedImageBytes!)
                            : null,
                        child: selectedImageBytes == null
                            ? const Icon(Icons.person, size: 55)
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 18,
                          child: const Icon(Icons.camera_alt, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Tap to select profile picture",
                  style: TextStyle(color: Colors.blueGrey),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Create Service Provider Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: firstNameController,
                        labelText: "First Name",
                        hintText: "First name",
                        prefixIcon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter first name";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomTextField(
                        controller: lastNameController,
                        labelText: "Last Name",
                        hintText: "Last name",
                        prefixIcon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter last name";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: employeeCodeController,
                  labelText: "Employee Code",
                  hintText: "Example: EMP005",
                  prefixIcon: Icons.badge_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter employee code";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: servicesController,
                  labelText: "Services",
                  hintText: "Example: Electrician, Plumber",
                  prefixIcon: Icons.home_repair_service_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter at least one service";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: descriptionController,
                  labelText: "Description",
                  hintText: "Describe your services",
                  prefixIcon: Icons.description_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter description";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: chargesController,
                  labelText: "Charges Per Hour",
                  hintText: "Example: 500",
                  prefixIcon: Icons.currency_rupee,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter charges";
                    }

                    if (int.tryParse(value.trim()) == null) {
                      return "Enter a valid amount";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: emailController,
                  labelText: "Email",
                  hintText: "Enter your email",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter email";
                    }

                    if (!value.contains("@") || !value.contains(".")) {
                      return "Enter a valid email";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: passwordController,
                  labelText: "Password",
                  hintText: "Enter your password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: obscurePassword,
                  textInputAction: TextInputAction.next,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter password";
                    }

                    if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: confirmPasswordController,
                  labelText: "Confirm Password",
                  hintText: "Re-enter your password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm your password";
                    }

                    if (value != passwordController.text) {
                      return "Passwords do not match";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: "Register",
                  isLoading: isLoading,
                  onPressed: registerProvider,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
