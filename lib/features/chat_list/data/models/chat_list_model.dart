import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListModel {
  final String chatId;
  final String peerId;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final String peerDisplayName;
  final String? peerPhotoUrl;

  const ChatListModel({
    required this.chatId,
    required this.peerId,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.peerDisplayName,
    this.peerPhotoUrl,
  });

  factory ChatListModel.fromFirestore({
    required DocumentSnapshot chatDoc,
    required DocumentSnapshot userDoc,
    required String myId,
  }) {
    final chatData = chatDoc.data() as Map<String, dynamic>;
    final userData = userDoc.data() as Map<String, dynamic>;

    final List<String> ids = List<String>.from(chatData['ids']);
    final String peerId = ids.firstWhere((id) => id != myId);

    return ChatListModel(
      chatId: chatDoc.id,
      peerId: peerId,
      lastMessage: chatData['last_message'] ?? '',
      lastMessageTimestamp: (chatData['time_stamp'] as Timestamp).toDate(),
      peerDisplayName: userData['displayName'] ?? 'User',
      peerPhotoUrl: userData['photoUrl'],
    );
  }
}
