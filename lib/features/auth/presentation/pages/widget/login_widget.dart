import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sagar_chat_demo/core/widgets/base_text.dart';
import 'package:sagar_chat_demo/core/widgets/base_text_field.dart';
import '../../../../../core/constants/app_route_constants.dart';
import '../../../../../core/constants/app_string_constants.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

class LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
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
                AppStringConstants.welcomeBack,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 10),
              const BaseText(
                AppStringConstants.loginToContinue,
                fontSize: 16,
                color: Colors.grey,
              ),
              const SizedBox(height: 40),
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
                  if (value == null || value.isEmpty) {
                    return AppStringConstants.pleaseEnterPassword;
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
                              context.read<AuthCubit>().login(
                                emailController.text.trim(),
                                passwordController.text,
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
                            AppStringConstants.login,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          context.push(AppRoutes.register);
                        },
                        child: const BaseText(AppStringConstants.dontHaveAccount),
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
