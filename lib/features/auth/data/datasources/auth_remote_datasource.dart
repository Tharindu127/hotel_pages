import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn if not already done
      await googleSignIn.initialize();

      // Check if platform supports authenticate
      if (googleSignIn.supportsAuthenticate()) {
        final GoogleSignInAccount account = await googleSignIn.authenticate(
          scopeHint: ['email', 'profile'],
        );

        final GoogleSignInAuthentication googleAuth = await account.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.idToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);

        if (userCredential.user == null) {
          throw const AuthException('Failed to sign in with Google');
        }

        return UserModel.fromFirebaseUser(userCredential.user!);
      } else {
        throw const AuthException('Platform does not support Google Sign-In');
      }
    } on GoogleSignInException catch (e) {
      print('Google Sign-In error: ${e.code.name} - ${e.description}');
      throw AuthException('Google Sign-In error: ${e.code.name} - ${e.description}');
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Firebase auth error');
    } catch (e) {
      throw AuthException('Unknown error: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Failed to sign out: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final User? firebaseUser = firebaseAuth.currentUser;
      return firebaseUser != null
          ? UserModel.fromFirebaseUser(firebaseUser)
          : null;
    } catch (e) {
      throw AuthException('Failed to get current user: $e');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((User? user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }
}