class ServiceProvider {
  final String name;
  final String image;
  final String service;
  final double rating;
  final int reviews;
  final int charges;

  const ServiceProvider({
    required this.name,
    required this.image,
    required this.service,
    required this.rating,
    required this.reviews,
    required this.charges,
  });
}
