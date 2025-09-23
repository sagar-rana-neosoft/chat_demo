import '../entities/profile_entity.dart';

// An abstract contract for user profile data operations.
// The cubit will depend on this abstraction, not the concrete implementation.
abstract class UserProfileRepository {
  Future<UserProfile> getUserProfile(String userId);
  Future<void> updateUserProfile({required String userId, required String displayName});
}
