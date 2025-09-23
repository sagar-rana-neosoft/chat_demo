import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call(String myId, String peerId, String messageText) {
    return repository.sendMessage(myId, peerId, messageText);
  }
}
