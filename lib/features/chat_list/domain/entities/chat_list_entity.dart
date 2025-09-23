class ChatListEntity {
  final String chatId;
  final String peerId;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final String peerDisplayName;
  final String? peerPhotoUrl;

  const ChatListEntity({
    required this.chatId,
    required this.peerId,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.peerDisplayName,
    this.peerPhotoUrl,
  });
}
