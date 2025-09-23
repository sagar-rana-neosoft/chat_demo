import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/repositories/internet_connection_repository.dart';

class InternetConnectionRepositoryImpl implements InternetConnectionRepository {
  final Connectivity _connectivity;

  InternetConnectionRepositoryImpl(this._connectivity);

  @override
  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map((result) {
     if(result.contains(ConnectivityResult.none)){
       return false;
     }
      return true;
    });
  }
}
