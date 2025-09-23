import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sagar_chat_demo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sagar_chat_demo/features/auth/presentation/cubit/auth_state.dart';
import '../../../../core/constants/app_route_constants.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        context.read<AuthCubit>().checkAuthStatus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<AuthCubit>().checkAuthStatus();
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated || state is AuthError) {
            context.go(AppRoutes.login);
          } else if (state is AuthAuthenticated) {
            context.go(AppRoutes.chatList);
          }
        },
        // The SizedBox is a placeholder. The main logic is in the listener.
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
