abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final dynamic user;
  AuthUserChanged(this.user);
}