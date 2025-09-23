import '../../domain/entities/chat_list_entity.dart';

abstract class ChatListState {}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatListEntity> chats;
  ChatListLoaded(this.chats);
}

class ChatListEmpty extends ChatListState {}

class ChatListError extends ChatListState {
  final String message;
  ChatListError(this.message);
}
