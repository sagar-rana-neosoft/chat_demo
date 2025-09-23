import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final List<String> readBy;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.readBy = const [],
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      senderId: data['sender_id'],
      receiverId: data['receiver_id'],
      message: data['message'],
      timestamp: data['time_stamp'],
      readBy: List<String>.from(data['readBy'] ?? []),
    );
  }
}
