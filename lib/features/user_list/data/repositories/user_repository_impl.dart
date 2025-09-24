import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  @override
  Stream<List<UserEntity>> getAllOtherUsers(String myUid) {
    return _firestore
        .collection(FirebaseConstants.usersCollection)
        .where('id', isNotEqualTo: myUid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final userModel = UserModel.fromFirestore(doc);
        return UserEntity(
          id: userModel.id,
          displayName: userModel.displayName,
          email: userModel.email,
          photoUrl: userModel.photoUrl,
        );
      }).toList();
    });
  }
}