import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:sagar_chat_demo/core/widgets/base_text.dart';
import 'package:sagar_chat_demo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sagar_chat_demo/features/auth/presentation/cubit/auth_state.dart';
import 'package:sagar_chat_demo/features/chat_list/presentation/pages/widgets/chat_list_error_widget.dart';
import 'package:sagar_chat_demo/features/chat_list/presentation/pages/widgets/chat_list_item.dart';
import '../../../../core/constants/app_route_constants.dart';
import '../../../../core/constants/app_string_constants.dart';
import '../../../../core/services/connectivity_service/presentation/cubit/internet_cubit.dart';
import '../../../../core/services/connectivity_service/presentation/cubit/internet_state.dart';
import '../../../../core/utils/tools_utils.dart';
import '../../../auth/presentation/pages/widget/login_widget.dart';
import '../cubit/chat_list_cubit.dart';
import '../cubit/chat_list_state.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ChatListCubit>().fetchChatList(
      FirebaseAuth.instance.currentUser!.uid,
    );

    return Scaffold(
      appBar: AppBar(
        title: const BaseText(
          AppStringConstants.chats,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String result) {
              switch (result) {
                case 'profile':
                  context.push(AppRoutes.userProfile);
                  break;
                case 'logout':
                  context.read<AuthCubit>().logout();
                  break;
                case 'userList':
                  context.push(AppRoutes.userList);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text(AppStringConstants.profile),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text(AppStringConstants.logout),
              ),
              const PopupMenuItem<String>(
                value: 'userList',
                child: Text(AppStringConstants.userList),
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go(AppRoutes.login);
          }
        },
        child: BlocListener<InternetCubit, InternetState>(
          listener: (context, state) {
            if (state is InternetDisconnected) {
              showCustomToast(
                message: AppStringConstants.internetNotAvailable,
                backgroundColor: Colors.red,
                gravity: ToastGravity.TOP,
                textColor: Colors.white,
              );
            }
          },
          child: RefreshIndicator(
            color: Colors.blueAccent,
            onRefresh: () async {
              final internetState = context.read<InternetCubit>().state;
              if (internetState is InternetConnected) {
                context.read<ChatListCubit>().fetchChatList(
                  FirebaseAuth.instance.currentUser!.uid,
                );
              } else {
                showCustomToast(
                  message: AppStringConstants.noInternetToRefresh,
                  gravity: ToastGravity.TOP,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            },
            child: GradientBackground(
              child: BlocBuilder<ChatListCubit, ChatListState>(
                builder: (context, state) {
                  if (state is ChatListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatListLoaded) {
                    if (state.chats.isEmpty) {
                      return const Center(child: BaseText(AppStringConstants.noChatsFound));
                    }
                    return ListView.builder(
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];
                        return ChatListItem(
                          chat: chat,
                          onTap: () => context.push('${AppRoutes.chatView}/${chat.peerId}'),
                        );
                      },
                    );
                  } else if (state is ChatListEmpty) {
                    return const Center(child: BaseText(AppStringConstants.noChatsFound));
                  } else if (state is ChatListError) {
                    return ChatListErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<ChatListCubit>().fetchChatList(
                          FirebaseAuth.instance.currentUser!.uid,
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
