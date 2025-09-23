import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sagar_chat_demo/core/widgets/base_text.dart';
import 'package:sagar_chat_demo/features/chat_view/domain/entities/message_entities.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final String myId;
  final String peerId;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    required this.myId,
    required this.peerId,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == myId;
    final isRead = message.readBy.contains(peerId);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.blueAccent : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
              bottomLeft: isMe ? const Radius.circular(16.0) : const Radius.circular(4.0),
              bottomRight: isMe ? const Radius.circular(4.0) : const Radius.circular(16.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              BaseText(
                message.message,
                color: isMe ? Colors.white : Colors.black,
                fontSize: 16.0,
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BaseText(
                    _formatTimestamp(message.timestamp),
                    color: isMe ? Colors.white70 : Colors.black54,
                    fontSize: 10.0,
                  ),
                  if (isMe)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.done_all,
                        size: 16.0,
                        color: isRead ? Colors.lightGreenAccent : Colors.white70,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return DateFormat.jm().format(timestamp);
    } else if (messageDate == yesterday) {
      return 'Yesterday, ${DateFormat.jm().format(timestamp)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }
}