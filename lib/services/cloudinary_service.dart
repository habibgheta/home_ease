import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String cloudName = "pj3psovz";
  static const String uploadPreset = "homeease_upload";

  static Future<String?> uploadImage(XFile imageFile) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", url);

    request.fields["upload_preset"] = uploadPreset;

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        await imageFile.readAsBytes(),
        filename: imageFile.name,
      ),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);

      return data["secure_url"];
    }

    return null;
  }
}
