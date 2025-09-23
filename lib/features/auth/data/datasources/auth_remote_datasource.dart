import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sagar_chat_demo/core/constants/firebase_constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String displayName);
  Future<void> logout();
  Stream<UserModel?> get authStateChanges;
  firebase_auth.User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userDoc = await firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(credential.user!.uid)
        .get();

    return UserModel.fromJson(userDoc.data()!);
  }

  @override
  Future<UserModel> register(String email, String password, String displayName) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = UserModel(
      id: credential.user!.uid,
      email: email,
      displayName: displayName,
    );

    await firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(credential.user!.uid)
        .set(user.toJson());

    return user;
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser != null) {
      try{
        final userDoc = await firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(firebaseUser.uid)
            .get();
        return UserModel.fromJson(userDoc.data()!);
      }
          catch(e){
        return null;
          }
      }
      return null;
    });
  }

  @override
  firebase_auth.User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }
}