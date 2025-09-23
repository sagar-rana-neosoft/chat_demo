
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final UserProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<void> call({required String userId, required String displayName}) {
    return repository.updateUserProfile(
      userId: userId,
      displayName: displayName,
    );
  }
}
