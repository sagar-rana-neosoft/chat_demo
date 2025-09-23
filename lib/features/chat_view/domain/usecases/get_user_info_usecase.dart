
import 'package:sagar_chat_demo/features/user_list/domain/entities/user_entity.dart';

import '../repositories/chat_repository.dart';

class GetUserInfoUseCase {
  final ChatRepository repository;

  GetUserInfoUseCase(this.repository);

  Future<UserEntity> call(String userId) {
    return repository.getUserInfo(userId);
  }
}
