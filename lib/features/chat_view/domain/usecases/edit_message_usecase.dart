import '../repositories/chat_repository.dart';

class EditMessageUseCase {
  final ChatRepository repository;

  const EditMessageUseCase(this.repository);

  Future<void> call(String chatId, String messageId, String newText) {
    return repository.editMessage(chatId, messageId, newText);
  }
}
