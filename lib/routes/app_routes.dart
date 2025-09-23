import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sagar_chat_demo/core/constants/app_route_constants.dart';
import 'package:sagar_chat_demo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sagar_chat_demo/features/auth/presentation/cubit/auth_state.dart';
import 'package:sagar_chat_demo/features/auth/presentation/pages/login_page.dart';
import 'package:sagar_chat_demo/features/auth/presentation/pages/register_page.dart';
import 'package:sagar_chat_demo/features/chat_list/presentation/pages/chat_list_view.dart';
import 'package:sagar_chat_demo/features/chat_view/presentation/pages/chat_view.dart';
import 'package:sagar_chat_demo/features/splash/splash_screen.dart';
import 'package:sagar_chat_demo/features/user_list/presentation/pages/user_list_view.dart';
import 'package:sagar_chat_demo/features/user_profile/presentation/pages/user_profile_view.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreenView(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.chatList,
      builder: (context, state) => const ChatListView(),
    ),
    GoRoute(
      path: '${AppRoutes.chatView}/:peerId',
      builder: (context, state) {
        final myId = (context.read<AuthCubit>().state as AuthAuthenticated).user.id;
        final peerId = state.pathParameters['peerId']!;
        return ChatView(myId: myId, peerId: peerId);
      },
    ),
    GoRoute(
      path: AppRoutes.userList,
      builder: (context, state) => const UserListScreen(),
    ),
    GoRoute(
      path: AppRoutes.userProfile,
      builder: (context, state) => const ProfileView(),
    ),
  ],
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
    final isAuthenticating = authState is AuthLoading;
    final isAuthenticated = authState is AuthAuthenticated;
    final isUnauthenticated = authState is AuthUnauthenticated || authState is AuthError;

    // List of routes that don't require authentication
    final authRoutes = [AppRoutes.splash, AppRoutes.login, AppRoutes.register];
    final isAuthRoute = authRoutes.contains(state.uri.path);

    // If still authenticating, wait.
    if (isAuthenticating) {
      return null;
    }

    // Redirect to login if unauthenticated and not already on an auth route.
    if (isUnauthenticated && !isAuthRoute) {
      return AppRoutes.login;
    }

    // Redirect to chat list if authenticated and trying to access an auth route.
    if (isAuthenticated && isAuthRoute) {
      return AppRoutes.chatList;
    }

    return null;
  },
);
