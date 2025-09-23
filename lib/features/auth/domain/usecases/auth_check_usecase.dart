import 'package:sagar_chat_demo/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  bool call() {
    return repository.getCurrentUser() != null;
  }
}