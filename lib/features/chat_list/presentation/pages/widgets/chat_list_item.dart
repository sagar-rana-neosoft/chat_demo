import 'package:flutter/material.dart';
import 'package:sagar_chat_demo/core/utils/date_formatter.dart';
import 'package:sagar_chat_demo/core/widgets/base_text.dart';
import '../../../domain/entities/chat_list_entity.dart';

class ChatListItem extends StatelessWidget {
  final ChatListEntity chat;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue[100],
          backgroundImage: chat.peerPhotoUrl != null
              ? NetworkImage(chat.peerPhotoUrl!)
              : null,
          child: chat.peerPhotoUrl == null
              ? const Icon(
            Icons.person,
            color: Colors.blueGrey,
          )
              : null,
        ),
        title: BaseText(
          chat.peerDisplayName,
          fontWeight: FontWeight.bold,
        ),
        subtitle: BaseText(
          chat.lastMessage,
          color: Colors.grey,
        ),
        trailing: BaseText(
          formatLastMessageTime(chat.lastMessageTimestamp),
          fontSize: 12,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
