class ServiceProvider {
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
      employeeCode: map["employeeCode"] ?? "",
      name: map["name"] ?? "",
      services: List<String>.from(map["services"] ?? []),
      description: map["description"] ?? "",
      status: map["status"] ?? "Available",
      rating: (map["rating"] ?? 0).toDouble(),
      reviews: map["reviews"] ?? 0,
      chargesPerHour: map["chargesPerHour"] ?? 0,
      imageUrl: map["imageUrl"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
