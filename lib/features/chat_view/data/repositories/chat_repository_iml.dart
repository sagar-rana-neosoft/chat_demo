import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sagar_chat_demo/core/constants/firebase_constants.dart';
import 'package:sagar_chat_demo/features/user_list/domain/entities/user_entity.dart';
import '../../../auth/data/models/user_model.dart';

import '../../domain/entities/message_entities.dart';

import '../../domain/repositories/chat_repository.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepositoryImpl(this._firestore);

  String _getChatId(String myId, String peerId) {
    return myId.compareTo(peerId) > 0 ? '$myId-$peerId' : '$peerId-$myId';
  }

  @override
  Future<UserEntity> getUserInfo(String userId) async {
    final doc = await _firestore.collection(FirebaseConstants.usersCollection).doc(userId).get();
    if (doc.exists) {
      final userModel = UserModel.fromFirestore(doc);
      return UserEntity(
        id: userModel.id,
        displayName: userModel.displayName,
        email: userModel.email,
      );
    }
    throw Exception('User not found');
  }

  @override
  Stream<List<MessageEntity>> getMessagesStream(String myId, String peerId) {
    final chatId = _getChatId(myId, peerId);
    return _firestore
        .collection(FirebaseConstants.chatsCollection)
        .doc(chatId)
        .collection(FirebaseConstants.chatsCollection)
        .orderBy('time_stamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final messageModel = MessageModel.fromFirestore(doc);
        return MessageEntity(
          id: messageModel.id,
          senderId: messageModel.senderId,
          receiverId: messageModel.receiverId,
          message: messageModel.message,
          timestamp: messageModel.timestamp.toDate(),
          readBy: messageModel.readBy
        );
      }).toList();
    });
  }

  @override
  Future<void> sendMessage(String myId, String peerId, String messageText) async {
    final chatId = _getChatId(myId, peerId);
    final chatDocRef = _firestore.collection(FirebaseConstants.chatsCollection).doc(chatId);
    final now = Timestamp.now();

    final chatDoc = await chatDocRef.get();
    if (!chatDoc.exists) {
      await chatDocRef.set({
        'ids': [myId, peerId],
        'last_message': messageText,
        'time_stamp': now,
      });
    } else {
      await chatDocRef.update({
        'last_message': messageText,
        'time_stamp': now,
      });
    }

    await chatDocRef.collection(FirebaseConstants.chatsCollection).add({
      'message': messageText,
      'sender_id': myId,
      'receiver_id': peerId,
      'time_stamp': now,
    });
  }

  @override
  Future<void> markMessageAsRead(String chatId, String messageId, String readerId) async {
    await _firestore
        .collection(FirebaseConstants.chatsCollection)
        .doc(chatId)
        .collection(FirebaseConstants.chatsCollection)
        .doc(messageId)
        .update({
      'readBy': FieldValue.arrayUnion([readerId]),
    });
  }
  @override
  Future<void> editMessage(
      String chatId, String messageId, String newText) async {
    final messageDocRef = _firestore
        .collection(FirebaseConstants.chatsCollection)
        .doc(chatId)
        .collection(FirebaseConstants.chatsCollection)
        .doc(messageId);

    await messageDocRef.update({
      'message': newText,
    });
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    final messageDocRef = _firestore
        .collection(FirebaseConstants.chatsCollection)
        .doc(chatId)
        .collection(FirebaseConstants.chatsCollection)
        .doc(messageId);

    await messageDocRef.delete();
  }
}
