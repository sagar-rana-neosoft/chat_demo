import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sagar_chat_demo/features/user_list/presentation/cubit/user_list_state.dart';
import '../../domain/usecases/get_all_other_users_use_case.dart';


class UserListCubit extends Cubit<UserListState> {
  final GetAllOtherUsersUseCase _getAllOtherUsersUseCase;

  UserListCubit(this._getAllOtherUsersUseCase) : super(UserListInitial());

  StreamSubscription? _userSubscription;

  void fetchOtherUsers(String myUid) {
    emit(UserListLoading());
    _userSubscription = _getAllOtherUsersUseCase(myUid).listen(
          (users) {
        if (users.isEmpty) {
          emit(UserListEmpty());
        } else {
          emit(UserListLoaded(users));
        }
      },
      onError: (error) {
        emit(UserListError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}