import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_list_entity.dart';
import '../../domain/usecases/get_chat_list_use_case.dart';
import 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final GetChatListUseCase _getChatListUseCase;
  StreamSubscription<List<ChatListEntity>>? _chatListSubscription;

  ChatListCubit(this._getChatListUseCase) : super(ChatListInitial());

  void fetchChatList(String myId) {
    emit(ChatListLoading());
    _chatListSubscription?.cancel();
    _chatListSubscription = _getChatListUseCase(myId).listen(
          (chats) {
        if (chats.isEmpty) {
          emit(ChatListEmpty());
        } else {
          emit(ChatListLoaded(chats));
        }
      },
      onError: (error) {
        emit(ChatListError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _chatListSubscription?.cancel();
    return super.close();
  }
}
