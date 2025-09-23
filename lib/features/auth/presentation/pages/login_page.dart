import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:sagar_chat_demo/features/auth/presentation/pages/widget/login_widget.dart';
import '../../../../core/constants/app_route_constants.dart';
import '../../../../core/utils/tools_utils.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showCustomToast(
              message: state.message,
              backgroundColor:Colors.redAccent,
              textColor: Colors.white,
              gravity: ToastGravity.BOTTOM,

            );
          } else if (state is AuthAuthenticated) {
            context.go(AppRoutes.chatList);
          } else if(state is AuthUnauthenticated){
            context.go(AppRoutes.login);
          }
        },
        child: GradientBackground(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: LoginCard(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
