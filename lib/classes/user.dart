class User {
  User(
      {required this.name,
      this.imageUrl = 'images/doctor_profile.png',
      this.accessToken,
      this.userType,
      required this.id});

  final String name;
  final String imageUrl;
  final String? accessToken;
  final String? userType;
  final String id;
}
