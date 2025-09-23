

import 'package:sagar_chat_demo/features/chat_view/domain/entities/message_entities.dart';
import 'package:sagar_chat_demo/features/user_list/domain/entities/user_entity.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final UserEntity peerUser;
  final List<MessageEntity> messages;

  ChatLoaded({required this.peerUser, required this.messages});
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}
