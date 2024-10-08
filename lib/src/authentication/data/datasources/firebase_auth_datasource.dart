import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn googleSignIn;

  FirebaseAuthDataSource(this._firebaseAuth, this.googleSignIn);

  Future<UserModel> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(credential.user!);
  }

  Future<UserModel> signUp(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(credential.user!);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await googleSignIn.signOut();
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In aborted by user');
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _firebaseAuth.signInWithCredential(credential);

      // Force reload the current user
      await userCredential.user?.reload();

      // Retrieve the updated user
      final updatedUser = _firebaseAuth.currentUser;

      if (updatedUser == null) {
        throw Exception('User is null after Google Sign-In');
      }

      return UserModel.fromFirebaseUser(updatedUser);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.idTokenChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

}
