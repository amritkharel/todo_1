import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> signIn(String email, String password);

  Future<User> signUp(String email, String password);

  Future<void> signOut();

  Future<User> signInWithGoogle();

  Stream<User?> get authStateChanges;
}
