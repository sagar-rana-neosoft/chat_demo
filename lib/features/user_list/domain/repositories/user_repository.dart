import '../entities/user_entity.dart';

abstract class UserRepository {
  Stream<List<UserEntity>> getAllOtherUsers(String myUid);
}