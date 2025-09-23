import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sagar_chat_demo/features/auth/domain/entities/user.dart';
import '../../../user_profile/domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/auth_check_usecase.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/usecases/usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final RegisterUser registerUser;
  final AuthRepository authRepository;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final GetUserProfileUseCase getUserProfileUseCase;

  late StreamSubscription _authStateSubscription;

  AuthCubit({
    required this.loginUser,
    required this.logoutUser,
    required this.registerUser,
    required this.authRepository,
    required this.getUserProfileUseCase,
    required this.checkAuthStatusUseCase
  }) : super(AuthInitial()) {

    _authStateSubscription = authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await loginUser(LoginParams(
      email: email,
      password: password,
    ));

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> register(String email, String password, String displayName) async {
    emit(AuthLoading());

    final result = await registerUser(RegisterParams(
      email: email,
      password: password,
      displayName: displayName,
    ));

    result.fold(
          (failure) => emit(AuthError(message: failure.toString())),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUser(NoParams());
    result.fold(
          (failure) => emit(AuthError(message: failure.toString())),
          (_) => emit(AuthUnauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
  Future checkAuthStatus() async {
    final user = firebaseAuth.FirebaseAuth.instance.currentUser;
    try {
      if (user!=null) {

        emit(AuthAuthenticated(user: User(id: user.uid, email: "", displayName: user.displayName!)));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Authentication check failed.'));
    }
  }
}