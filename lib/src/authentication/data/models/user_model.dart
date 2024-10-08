import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.uid, required super.email});

  factory UserModel.fromFirebaseUser(fire_auth.User user) {
    return UserModel(uid: user.uid, email: user.email ?? '');
  }
}
