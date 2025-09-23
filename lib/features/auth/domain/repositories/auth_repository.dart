import 'package:dartz/dartz.dart';
import 'package:sagar_chat_demo/core/erros/failures.dart';
import '../entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String email, String password, String displayName);
  Future<Either<Failure, void>> logout();
  Stream<User?> get authStateChanges;
  firebaseAuth.User? getCurrentUser();
}