import '../entities/chat_list_entity.dart';
import '../repositories/chat_list_repository.dart';

class GetChatListUseCase {
  final ChatListRepository repository;

  GetChatListUseCase(this.repository);

  Stream<List<ChatListEntity>> call(String myId) {
    return repository.getChatList(myId);
  }
}
