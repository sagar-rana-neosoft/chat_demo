import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sagar_chat_demo/core/widgets/base_text.dart';
import 'package:sagar_chat_demo/features/user_list/presentation/pages/widgets/user_list_item.dart';
import '../../../../core/constants/app_string_constants.dart';
import '../cubit/user_list_cubit.dart';
import '../cubit/user_list_state.dart';


class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserListCubit>();
    cubit.fetchOtherUsers(FirebaseAuth.instance.currentUser!.uid);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const BaseText(
          AppStringConstants.contacts,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD), // A light blue
              Color(0xFFBBDEFB), // A slightly darker blue
            ],
          ),
        ),
        child: BlocBuilder<UserListCubit, UserListState>(
          builder: (context, state) {
            if (state is UserListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserListLoaded) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return UserListItem(user: user);
                },
              );
            } else if (state is UserListEmpty) {
              return const Center(child: BaseText(AppStringConstants.noOtherUsersFound));
            } else if (state is UserListError) {
              return Center(child: BaseText('${AppStringConstants.error}${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
