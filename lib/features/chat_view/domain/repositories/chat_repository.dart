

import '../../../user_list/domain/entities/user_entity.dart';
import '../entities/message_entities.dart';

abstract class ChatRepository {
  Future<UserEntity> getUserInfo(String userId);
  Stream<List<MessageEntity>> getMessagesStream(String myId, String peerId);
  Future<void> sendMessage(String myId, String peerId, String messageText);
  Future<void> markMessageAsRead(String chatId, String messageId, String readerId);
  Future<void> editMessage(String chatId, String messageId, String newText);
  Future<void> deleteMessage(String chatId, String messageId);
}
