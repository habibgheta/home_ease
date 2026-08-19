import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> isAdmin(String uid) async {
    final document = await _firestore.collection("admins").doc(uid).get();

    if (!document.exists) {
      return false;
    }

    return document.data()?["role"] == "admin";
  }
}
