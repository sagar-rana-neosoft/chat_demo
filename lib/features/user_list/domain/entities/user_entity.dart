class UserEntity {
  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;

  UserEntity({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });
}