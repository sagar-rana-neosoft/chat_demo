import '../repositories/chat_repository.dart';

class MarkMessageAsReadUseCase {
  final ChatRepository repository;

  MarkMessageAsReadUseCase(this.repository);

  Future<void> call(String chatId, String messageId, String readerId) {
    return repository.markMessageAsRead(chatId, messageId, readerId);
  }
}