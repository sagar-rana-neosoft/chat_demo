import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sagar_chat_demo/core/services/connectivity_service/presentation/cubit/internet_state.dart';
import 'package:sagar_chat_demo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sagar_chat_demo/features/chat_list/presentation/cubit/chat_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sagar_chat_demo/features/user_profile/presentation/cubit/user_profile_cubit.dart';
import 'package:sagar_chat_demo/routes/app_routes.dart';
import 'core/services/connectivity_service/data/repositories/internet_connection_repo_impl.dart';
import 'core/services/connectivity_service/domain/usecases/check_internet_connection_usecase.dart';
import 'core/services/connectivity_service/presentation/cubit/internet_cubit.dart';
import 'core/shared/injection_container.dart';
import 'core/utils/tools_utils.dart';
import 'features/chat_view/presentation/cubit/chat_cubit.dart';
import 'features/user_list/presentation/cubit/user_list_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initDependencies();
  final authCubit = sl<AuthCubit>();
  runApp(MyApp(authCubit: authCubit));
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;
  const MyApp({super.key, required this.authCubit});

  @override
  Widget build(BuildContext context) {
    final userListCubit = sl<UserListCubit>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<UserListCubit>()),
        BlocProvider(create: (_) => sl<ChatCubit>()),
        BlocProvider(create: (_) => sl<ChatListCubit>()),
        BlocProvider(create: (_) => sl<UserProfileCubit>()),
        BlocProvider<InternetCubit>(
          create: (context) => InternetCubit(
            CheckInternetConnectionUseCase(
              InternetConnectionRepositoryImpl(Connectivity()),
            ),
          ),
        ),
      ],
      child: BlocListener<InternetCubit, InternetState>(
        listenWhen: (previous, current) {
          return (previous is InternetDisconnected && current is InternetConnected) ||
              (previous is InternetConnected && current is InternetDisconnected);
        },
        listener: (context, state) {
          if (state is InternetDisconnected) {
            showCustomToast(
              message: "Internet is not available",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              gravity: ToastGravity.TOP,
            );
          } else if (state is InternetConnected) {
            showCustomToast(
              message: "Internet connected!",
              backgroundColor: Colors.green,
              textColor: Colors.white,
              gravity: ToastGravity.TOP,
            );
          }
        },
        child:MaterialApp.router(routerConfig: router),
      ),
    );
  }
}
