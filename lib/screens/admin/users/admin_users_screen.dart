import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> users = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final snapshot = await _firestore.collection("users").get();

      if (!mounted) return;

      setState(() {
        users = snapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      debugPrint("Admin user loading error: $e");
    }
  }

  Future<void> deleteUser(
    QueryDocumentSnapshot<Map<String, dynamic>> user,
  ) async {
    final data = user.data();

    final name = data["firstName"] != null
        ? "${data["firstName"]} ${data["lastName"] ?? ""}".trim()
        : data["name"] ?? "this user";

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: Text(
            "Are you sure you want to delete $name's "
            "Firestore profile?",
          ),
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
      await _firestore.collection("users").doc(user.id).delete();

      if (!mounted) return;

      await loadUsers();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User deleted successfully.")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Unable to delete user.")));

      debugPrint("User delete error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(
              child: Text("No users found.", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final data = user.data();

                final firstName = data["firstName"] ?? "";

                final lastName = data["lastName"] ?? "";

                final name = "$firstName $lastName".trim();

                final email = data["email"] ?? "No email";

                final displayName = name.isEmpty ? "User" : name;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(displayName.substring(0, 1).toUpperCase()),
                    ),
                    title: Text(
                      displayName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(email),
                        const SizedBox(height: 2),
                        Text(
                          "UID: ${user.id}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteUser(user);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
