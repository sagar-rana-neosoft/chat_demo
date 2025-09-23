import 'package:dartz/dartz.dart';
import 'package:sagar_chat_demo/core/erros/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;


  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } on firebaseAuth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: "Email Id or password wrong"));
    }
  }

  @override
  Future<Either<Failure, User>> register(String email, String password, String displayName) async {
    try {
      final user = await remoteDataSource.register(email, password, displayName);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  @override
  firebaseAuth.User? getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Stream<User?> get authStateChanges => remoteDataSource.authStateChanges;
}