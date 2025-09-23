import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_internet_connection_usecase.dart';
import 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final CheckInternetConnectionUseCase _checkInternetConnectionUseCase;
  late StreamSubscription _streamSubscription;

  InternetCubit(this._checkInternetConnectionUseCase) : super(InternetInitial()) {
    _monitorConnection();
  }

  void _monitorConnection() {
    _streamSubscription = _checkInternetConnectionUseCase.call().listen((isConnected) {
      if (isConnected) {
        emit(InternetConnected());
      } else {
        emit(InternetDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
