import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationService {
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
  });

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> deleteUser();

  Future<void> signOut();

  Future<User?> getCurrentUser();

  bool isUserLoggedIn();
}
