import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetAllOtherUsersUseCase {
  final UserRepository repository;

  GetAllOtherUsersUseCase(this.repository);

  Stream<List<UserEntity>> call(String myUid) {
    return repository.getAllOtherUsers(myUid);
  }
}