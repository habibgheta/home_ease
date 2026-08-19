import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_ease/models/app_user.dart';

class UserService {
  static Future<AppUser?> getCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    final document = await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .get();

    if (!document.exists) {
      return null;
    }

    return AppUser.fromMap(document.data()!);
  }

  static Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String photoUrl,
  }) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      throw Exception("User is not logged in.");
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .update({
          "firstName": firstName,
          "lastName": lastName,
          "photoUrl": photoUrl,
        });
  }
}
