class ServiceCategory {
  final String name;
  final String iconName;
  final bool isActive;
  final int displayOrder;

  const ServiceCategory({
    required this.name,
    required this.iconName,
    required this.isActive,
    required this.displayOrder,
  });

  factory ServiceCategory.fromMap(Map<String, dynamic> map) {
    return ServiceCategory(
      name: map["name"] ?? "",
      iconName: map["icon"] ?? "",
      isActive: map["isActive"] ?? true,
      displayOrder: map["displayOrder"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "icon": iconName,
      "isActive": isActive,
      "displayOrder": displayOrder,
    };
  }
}
