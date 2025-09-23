import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/message_entities.dart';
import '../../domain/usecases/delete_message_usecase.dart';
import '../../domain/usecases/edit_message_usecase.dart';
import '../../domain/usecases/get_message_stream_usercase.dart';
import '../../domain/usecases/get_user_info_usecase.dart';
import '../../domain/usecases/mark_message_as_read_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetUserInfoUseCase _getUserInfoUseCase;
  final GetMessagesStreamUseCase _getMessagesStreamUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final MarkMessageAsReadUseCase _markMessageAsReadUseCase;
  final EditMessageUseCase _editMessageUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;

  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  ChatCubit(
      this._getUserInfoUseCase,
      this._getMessagesStreamUseCase,
      this._sendMessageUseCase,
      this._markMessageAsReadUseCase,
      this._deleteMessageUseCase,
      this._editMessageUseCase
      ) : super(ChatInitial());

  void loadChat(String myId, String peerId) async {
    emit(ChatLoading());
    try {
      final peerUser = await _getUserInfoUseCase(peerId);

      _messagesSubscription = _getMessagesStreamUseCase(myId, peerId).listen(
            (messages) {

              final chatId = _getChatId(myId, peerId);
              final unreadMessages = messages.where((message) =>
              message.senderId == peerId && !message.readBy.contains(myId)).toList();

              for (var message in unreadMessages) {
                _markMessageAsReadUseCase(chatId, message.id, myId);
              }
          emit(ChatLoaded(peerUser: peerUser, messages: messages));
        },
        onError: (error) {
          emit(ChatError('Failed to load chat: $error'));
        },
      );
    } catch (e) {
      emit(ChatError('Failed to load user info: $e'));
    }
  }
  String _getChatId(String myId, String peerId) {
    return myId.compareTo(peerId) > 0 ? '$myId-$peerId' : '$peerId-$myId';
  }
  void editMessage(String myId, String peerId, String messageId, String newText) async {
    try {
      final chatId = _getChatId(myId, peerId);
      await _editMessageUseCase(chatId, messageId, newText);
    } catch (e) {

    }
  }

  void deleteMessage(String myId, String peerId, String messageId) async {
    try {
      final chatId = _getChatId(myId, peerId);
      await _deleteMessageUseCase(chatId, messageId);
    } catch (e) {

    }
  }

  void sendMessage(String myId, String peerId, String messageText) async {
    try {
      await _sendMessageUseCase(myId, peerId, messageText);
    } catch (e) {
    }
  }


  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
