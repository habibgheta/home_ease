import 'package:flutter/material.dart';
import 'package:home_ease/models/service_category.dart';
import 'package:home_ease/services/category_service.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  List<ServiceCategory> categories = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final result = await CategoryService.getAllCategories();

      if (!mounted) return;

      setState(() {
        categories = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      debugPrint("Admin category loading error: $e");
    }
  }

  Future<void> deleteCategory(ServiceCategory category) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: Text("Are you sure you want to delete ${category.name}?"),
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
      await CategoryService.deleteCategory(category.name);

      if (!mounted) return;

      await loadCategories();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category deleted successfully.")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to delete category.")),
      );

      debugPrint("Category delete error: $e");
    }
  }

  Future<void> openCategoryForm({ServiceCategory? category}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AdminCategoryFormScreen(category: category),
      ),
    );

    if (result == true) {
      loadCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Categories")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openCategoryForm();
        },
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
          ? const Center(child: Text("No service categories found."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      _getIcon(category.iconName),
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),

                    title: Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      "Order: ${category.displayOrder}\n"
                      "Status: ${category.isActive ? "Active" : "Inactive"}",
                    ),

                    isThreeLine: true,

                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "edit") {
                          openCategoryForm(category: category);
                        } else if (value == "delete") {
                          deleteCategory(category);
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

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case "electrical_services":
        return Icons.electrical_services;

      case "plumbing":
        return Icons.plumbing;

      case "carpenter":
        return Icons.handyman;

      case "format_paint":
        return Icons.format_paint;

      case "cleaning_services":
        return Icons.cleaning_services;

      default:
        return Icons.home_repair_service;
    }
  }
}

class AdminCategoryFormScreen extends StatefulWidget {
  const AdminCategoryFormScreen({super.key, this.category});

  final ServiceCategory? category;

  @override
  State<AdminCategoryFormScreen> createState() =>
      _AdminCategoryFormScreenState();
}

class _AdminCategoryFormScreenState extends State<AdminCategoryFormScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController iconController;
  late final TextEditingController orderController;

  bool isActive = true;
  bool isSaving = false;

  bool get isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();

    final category = widget.category;

    nameController = TextEditingController(text: category?.name ?? "");

    iconController = TextEditingController(text: category?.iconName ?? "");

    orderController = TextEditingController(
      text: category?.displayOrder.toString() ?? "0",
    );

    isActive = category?.isActive ?? true;
  }

  @override
  void dispose() {
    nameController.dispose();
    iconController.dispose();
    orderController.dispose();
    super.dispose();
  }

  Future<void> saveCategory() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final category = ServiceCategory(
        name: nameController.text.trim(),
        iconName: iconController.text.trim(),
        isActive: isActive,
        displayOrder: int.parse(orderController.text.trim()),
      );

      if (isEditing) {
        await CategoryService.updateCategory(category);
      } else {
        await CategoryService.addCategory(category);
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
          content: Text("Unable to save category. Please try again."),
        ),
      );

      debugPrint("Category save error: $e");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Category" : "Add Category")),

      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameController,
              enabled: !isEditing,
              decoration: const InputDecoration(
                labelText: "Category Name",
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: iconController,
              decoration: const InputDecoration(
                labelText: "Icon Name",
                hintText: "cleaning_services",
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: orderController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Display Order",
                border: OutlineInputBorder(),
              ),
              validator: numberField,
            ),

            const SizedBox(height: 8),

            SwitchListTile(
              title: const Text("Active"),
              value: isActive,
              onChanged: (value) {
                setState(() {
                  isActive = value;
                });
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveCategory,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : Text(isEditing ? "Update Category" : "Add Category"),
              ),
            ),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
