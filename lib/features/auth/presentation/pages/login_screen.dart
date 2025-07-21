import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AuthAuthenticated) {
          // Navigate to home when authenticated
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: const CustomAppBar(title: 'Login', showBackButton: false),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return isLoading
                      ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      )
                  )
                      : IconButton(
                    onPressed: isLoading
                        ? null
                        : () => context.read<AuthBloc>().add(AuthGoogleSignInRequested()),
                    iconSize: 100,
                    color: AppColors.white,
                    icon: SvgPicture.asset(AppAssets.googleIcon),
                  );
                },
              ),
              const SizedBox(height: 30),
              Text(
                  'Login with Google',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.primaryTextStyle
              ),
            ],
          ),
        ),
      ),
    );
  }
}