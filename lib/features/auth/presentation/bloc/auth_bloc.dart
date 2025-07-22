import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/google_signin_usecases.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleSignInUseCase googleSignInUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  late StreamSubscription<UserEntity?> _authStateSubscription;

  AuthBloc({
    required this.googleSignInUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthUserChanged>(_onUserChanged);

    _authStateSubscription = getCurrentUserUseCase.authStateChanges.listen(
          (user) => add(AuthUserChanged(user)),
    );
  }

  void _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    print('Checking current auth state...');
    emit(AuthLoading());

    final result = await getCurrentUserUseCase();
    result.fold(
          (failure) {
        print('Auth check failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
          (user) {
        if (user != null) {
          print('User is authenticated: ${user.email}');
          emit(AuthAuthenticated(user));
        } else {
          print('No authenticated user found');
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  void _onGoogleSignInRequested(AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {
    print('Starting Google sign-in process...');
    emit(AuthLoading());

    final result = await googleSignInUseCase();
    result.fold(
          (failure) {
        print('Google sign-in failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
          (user) {
        print('Google sign-in successful: ${user.email}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  void _onSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    print('Starting sign-out process...');
    emit(AuthLoading());

    final result = await logoutUseCase();
    result.fold(
          (failure) {
        print('Sign-out failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
          (_) {
        print('Sign-out successful');
        emit(AuthUnauthenticated());
      },
    );
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      print('Auth state stream: User logged in');
      emit(AuthAuthenticated(event.user));
    } else {
      print('Auth state stream: User logged out');
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}