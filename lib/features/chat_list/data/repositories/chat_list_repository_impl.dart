import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../domain/entities/chat_list_entity.dart';
import '../../domain/repositories/chat_list_repository.dart';
import '../models/chat_list_model.dart';
import 'package:rxdart/rxdart.dart';

class ChatListRepositoryImpl implements ChatListRepository {
  final FirebaseFirestore _firestore;

  ChatListRepositoryImpl(this._firestore);

  @override
  Stream<List<ChatListEntity>> getChatList(String myId) {
    return _firestore
        .collection(FirebaseConstants.chatsCollection)
        .where('ids', arrayContains: myId)
        .snapshots()
        .flatMap((chatSnapshot) {
      if (chatSnapshot.docs.isEmpty) {
        return Stream.value([]);
      }

      final List<String> peerIds = chatSnapshot.docs.map((doc) {
        final List<String> ids = List<String>.from(doc.data()['ids']);
        return ids.firstWhere((id) => id != myId);
      }).toList();

      return _firestore
          .collection(FirebaseConstants.usersCollection)
          .where(FieldPath.documentId, whereIn: peerIds)
          .snapshots()
          .map((userSnapshot) {
        final Map<String, DocumentSnapshot> userDocsMap = {
          for (var doc in userSnapshot.docs) doc.id: doc
        };

        return chatSnapshot.docs.map((chatDoc) {
          final List<String> ids = List<String>.from(chatDoc.data()['ids']);
          final String peerId = ids.firstWhere((id) => id != myId);
          final userDoc = userDocsMap[peerId];

          if (userDoc == null) {

            return ChatListEntity(
              chatId: chatDoc.id,
              peerId: peerId,
              lastMessage: chatDoc.data()['last_message'],
              lastMessageTimestamp: (chatDoc.data()['time_stamp'] as Timestamp).toDate(),
              peerDisplayName: 'Unknown User',
              peerPhotoUrl: null,
            );
          }

          final chatListModel = ChatListModel.fromFirestore(
            chatDoc: chatDoc,
            userDoc: userDoc,
            myId: myId,
          );

          return ChatListEntity(
            chatId: chatListModel.chatId,
            peerId: chatListModel.peerId,
            lastMessage: chatListModel.lastMessage,
            lastMessageTimestamp: chatListModel.lastMessageTimestamp,
            peerDisplayName: chatListModel.peerDisplayName,
            peerPhotoUrl: chatListModel.peerPhotoUrl,
          );
        }).toList()..sort((a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp));
      });
    });
  }
}
