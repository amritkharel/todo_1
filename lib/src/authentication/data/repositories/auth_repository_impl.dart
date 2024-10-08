import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<User> signIn(String email, String password) async {
    return await dataSource.signIn(email, password);
  }

  @override
  Future<User> signUp(String email, String password) async {
    return await dataSource.signUp(email, password);
  }

  @override
  Future<void> signOut() async {
    await dataSource.signOut();
  }

  @override
  Future<User> signInWithGoogle() async {
    return await dataSource.signInWithGoogle();
  }

  @override
  Stream<User?> get authStateChanges => dataSource.authStateChanges;
}
