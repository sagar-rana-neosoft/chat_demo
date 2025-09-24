import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_string_constants.dart';
import '../../../../../core/widgets/base_text.dart';
import '../../../../../core/widgets/base_text_field.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';

class RegisterCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController displayNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterCard({
    super.key,
    required this.formKey,
    required this.displayNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BaseText(
                AppStringConstants.createYourAccount,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 10),
              const BaseText(
                AppStringConstants.joinUs,
                fontSize: 16,
                color: Colors.grey,
              ),
              const SizedBox(height: 40),
              BaseTextField(
                controller: displayNameController,
                labelText: AppStringConstants.displayName,
                prefixIcon: const Icon(Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStringConstants.pleaseEnterDisplayName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              BaseTextField(
                controller: emailController,
                labelText: AppStringConstants.email,
                prefixIcon: const Icon(Icons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStringConstants.pleaseEnterEmail;
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return AppStringConstants.validEmailAddress;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              BaseTextField(
                controller: passwordController,
                labelText: AppStringConstants.password,
                prefixIcon: const Icon(Icons.lock),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return AppStringConstants.passwordMinLength;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16,),
              BaseTextField(
                controller: confirmPasswordController,
                labelText: AppStringConstants.confirmPassword,
                prefixIcon: const Icon(Icons.lock),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return AppStringConstants.passwordMinLength;
                  }else if(value!= passwordController.text){
                    return AppStringConstants.confirmPasswordNotMatched;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthCubit>().register(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                displayNameController.text,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: const BaseText(
                            AppStringConstants.register,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const BaseText(AppStringConstants.alreadyHaveAccount),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
