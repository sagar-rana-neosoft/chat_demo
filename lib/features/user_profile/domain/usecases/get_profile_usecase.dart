import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';
class GetUserProfileUseCase {
  final UserProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfile> call(String userId) {
    return repository.getUserProfile(userId);
  }
}
