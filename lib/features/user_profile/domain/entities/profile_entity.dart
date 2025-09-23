// A simple data model that represents a user's profile.
// This is part of the Domain Layer.
class UserProfile {
  final String id;
  final String displayName;
  final String? photoUrl;

  const UserProfile({
    required this.id,
    required this.displayName,
    this.photoUrl,
  });
}
