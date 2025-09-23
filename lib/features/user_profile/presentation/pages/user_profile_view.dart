import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sagar_chat_demo/core/widgets/base_text.dart';
import 'package:sagar_chat_demo/core/widgets/base_text_field.dart';
import 'package:sagar_chat_demo/features/user_profile/presentation/cubit/user_profile_cubit.dart';
import 'package:sagar_chat_demo/features/user_profile/presentation/cubit/user_profile_state.dart';
import '../../../auth/presentation/pages/widget/login_widget.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _displayNameController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().fetchUserProfile(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText('Edit Profile', color: Colors.white, fontWeight: FontWeight.bold),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: GradientBackground(
        child: BlocConsumer<UserProfileCubit, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is UserProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is UserProfileLoaded) {
              _displayNameController.text = state.userProfile.displayName;
            }
          },
          builder: (context, state) {
            UserProfile? userProfile;
            if (state is UserProfileLoaded) {
              userProfile = state.userProfile;
            }

            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      BaseTextField(
                        controller: _displayNameController,
                        labelText: 'Display Name',
                        prefixIcon: const Icon(Icons.person),
                        enabled: state is! UserProfileUpdating && state is! UserProfileUpdatingPhoto,
                      ),
                      const SizedBox(height: 24.0),
                      if (state is UserProfileUpdating)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<UserProfileCubit>().updateProfile(
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                displayName: _displayNameController.text,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            child: const BaseText(
                              'Update Profile',
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
