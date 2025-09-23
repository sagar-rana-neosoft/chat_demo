import '../entities/message_entities.dart';
import '../repositories/chat_repository.dart';

class GetMessagesStreamUseCase {
  final ChatRepository repository;

  GetMessagesStreamUseCase(this.repository);

  Stream<List<MessageEntity>> call(String myId, String peerId) {
    return repository.getMessagesStream(myId, peerId);
  }
}
