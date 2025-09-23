import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sagar_chat_demo/core/services/connectivity_service/data/repositories/internet_connection_repo_impl.dart';
import 'package:sagar_chat_demo/core/services/connectivity_service/presentation/cubit/internet_cubit.dart';
import 'package:sagar_chat_demo/features/chat_list/data/repositories/chat_list_repository_impl.dart';
import 'package:sagar_chat_demo/features/chat_list/domain/repositories/chat_list_repository.dart';
import 'package:sagar_chat_demo/features/chat_list/domain/usecases/get_chat_list_use_case.dart';
import 'package:sagar_chat_demo/features/user_profile/data/repositories/profile_repository_impl.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_check_usecase.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/logout_user.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/chat_list/presentation/cubit/chat_list_cubit.dart';
import '../../features/chat_view/data/repositories/chat_repository_iml.dart';
import '../../features/chat_view/domain/repositories/chat_repository.dart';
import '../../features/chat_view/domain/usecases/delete_message_usecase.dart';
import '../../features/chat_view/domain/usecases/edit_message_usecase.dart';
import '../../features/chat_view/domain/usecases/get_message_stream_usercase.dart';
import '../../features/chat_view/domain/usecases/get_user_info_usecase.dart';
import '../../features/chat_view/domain/usecases/mark_message_as_read_usecase.dart';
import '../../features/chat_view/domain/usecases/send_message_usecase.dart';
import '../../features/chat_view/presentation/cubit/chat_cubit.dart';
import '../../features/user_list/data/repositories/user_repository_impl.dart';
import '../../features/user_list/domain/repositories/user_repository.dart';
import '../../features/user_list/domain/usecases/get_all_other_users_use_case.dart';
import '../../features/user_list/presentation/cubit/user_list_cubit.dart';
import '../../features/user_profile/domain/repositories/profile_repository.dart';
import '../../features/user_profile/domain/usecases/get_profile_usecase.dart';
import '../../features/user_profile/domain/usecases/update_profile_usecase.dart';
import '../../features/user_profile/presentation/cubit/user_profile_cubit.dart';
import '../services/connectivity_service/domain/repositories/internet_connection_repository.dart';
import '../services/connectivity_service/domain/usecases/check_internet_connection_usecase.dart';



final sl = GetIt.instance;

Future<void> initDependencies() async {
  ///Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  /// Internet Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  /// RemoteDataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(firebaseAuth: sl(),firestore: sl()),
  );
  /// Repository Implement
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserRepository>(()=> UserRepositoryImpl(sl()));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerLazySingleton<UserProfileRepository>(() => UserProfileRepositoryImpl());
  sl.registerLazySingleton<InternetConnectionRepository>(() => InternetConnectionRepositoryImpl(sl()));
  sl.registerLazySingleton<ChatListRepository>(()=> ChatListRepositoryImpl(sl()));

  /// Use Cases
  sl.registerLazySingleton(() => GetUserInfoUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesStreamUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => MarkMessageAsReadUseCase(sl()));
  sl.registerLazySingleton(() => GetChatListUseCase(sl()));
  sl.registerLazySingleton(() => EditMessageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetAllOtherUsersUseCase(sl()));
  sl.registerLazySingleton(() => CheckInternetConnectionUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));


  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  /// Cuibts
  sl.registerFactory(() => AuthCubit(
    loginUser: sl(),
    logoutUser: sl(),
    registerUser: sl(),
    authRepository: sl(),
    getUserProfileUseCase: sl(), checkAuthStatusUseCase: sl(),

  ));
  sl.registerFactory(()=> UserListCubit(sl()));
  sl.registerFactory(()=> UserProfileCubit(sl(),sl()));
  sl.registerFactory(()=> InternetCubit(sl()));
  sl.registerFactory(() => ChatCubit(sl(), sl(), sl(),sl(),sl(),sl()));
  sl.registerFactory(() => ChatListCubit(sl()));
}
