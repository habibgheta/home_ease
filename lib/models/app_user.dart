class AppUser {
  final String firstName;
  final String lastName;
  final String email;
  final String photoUrl;

  const AppUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.photoUrl,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      firstName: map["firstName"] ?? "",
      lastName: map["lastName"] ?? "",
      email: map["email"] ?? "",
      photoUrl: map["photoUrl"] ?? "",
    );
  }
}
