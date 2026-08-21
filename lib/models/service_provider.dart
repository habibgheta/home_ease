class ServiceProvider {
  final String uid;
  final String employeeCode;
  final String name;
  final List<String> services;
  final String description;
  final String status;
  final double rating;
  final int reviews;
  final int chargesPerHour;
  final String imageUrl;

  const ServiceProvider({
    this.uid = "",
    required this.employeeCode,
    required this.name,
    required this.services,
    required this.description,
    required this.status,
    required this.rating,
    required this.reviews,
    required this.chargesPerHour,
    required this.imageUrl,
  });

  factory ServiceProvider.fromMap(Map<String, dynamic> map) {
    return ServiceProvider(
      uid: map["uid"] ?? "",
      employeeCode: map["employeeCode"] ?? "",
      name: map["name"] ?? "",
      services: List<String>.from(map["services"] ?? []),
      description: map["description"] ?? "",
      status: map["status"] ?? "Available",
      rating: (map["rating"] ?? 0).toDouble(),
      reviews: (map["reviews"] ?? 0).toInt(),
      chargesPerHour: (map["chargesPerHour"] ?? 0).toInt(),
      imageUrl: map["imageUrl"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "employeeCode": employeeCode,
      "name": name,
      "services": services,
      "description": description,
      "status": status,
      "rating": rating,
      "reviews": reviews,
      "chargesPerHour": chargesPerHour,
      "imageUrl": imageUrl,
    };
  }
}
