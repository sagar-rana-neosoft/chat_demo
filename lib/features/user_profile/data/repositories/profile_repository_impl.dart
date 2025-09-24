
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sagar_chat_demo/core/constants/firebase_constants.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirebaseFirestore _firestore;


  UserProfileRepositoryImpl({
    FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? FirebaseFirestore.instance;


  @override
  Future<UserProfile> getUserProfile(String userId) async {
    final docRef = _firestore.collection(FirebaseConstants.usersCollection).doc(userId);
    final docSnapshot = await docRef.get();
      final data = docSnapshot.data() as Map<String, dynamic>;
      return UserProfile(
        id: docSnapshot.id,
        displayName: data['displayName'] ?? '',
        photoUrl: "",
      );

  }

  @override
  Future<void> updateUserProfile({required String userId, required String displayName}) async {
    final docRef = _firestore.collection(FirebaseConstants.usersCollection).doc(userId);
    await docRef.update({'displayName': displayName});
  }


}
