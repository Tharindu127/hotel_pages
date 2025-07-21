import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_pages/features/auth/presentation/pages/login_screen.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthWrapper extends StatelessWidget {

  const AuthWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Handle side effects if needed
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case AuthInitial:
            context.read<AuthBloc>().add(AuthCheckRequested());
            return const _LoadingScreen();

          case AuthLoading:
            return const _LoadingScreen();

          case AuthAuthenticated:
            return HomeScreen();

          case AuthUnauthenticated:
            return const LoginScreen();

          case AuthError:
            return const LoginScreen();

          default:
            return const LoginScreen();
        }
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}