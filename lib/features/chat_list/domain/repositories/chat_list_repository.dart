import '../entities/chat_list_entity.dart';

abstract class ChatListRepository {
  Stream<List<ChatListEntity>> getChatList(String myId);
}
