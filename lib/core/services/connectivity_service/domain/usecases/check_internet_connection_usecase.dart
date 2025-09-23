import '../repositories/internet_connection_repository.dart';

class CheckInternetConnectionUseCase {
  final InternetConnectionRepository repository;

  CheckInternetConnectionUseCase(this.repository);

  Stream<bool> call() {
    return repository.connectionStream;
  }
}
