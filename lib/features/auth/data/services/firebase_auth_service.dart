import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/networking/authentication_service.dart';

class FirebaseAuthService extends AuthenticationService {
  @override
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        "Exception in FirebaseAuthServices.createUserWithEmailAndPassword: $e & error code is ${e.code}",
      );
      if (e.code == 'weak-password') {
        throw CustomException('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('The account already exists for that email.');
      } else if (e.code == 'network-request-failed') {
        throw CustomException('No internet connection');
      } else {
        throw CustomException("An Error occurred, please try again later.");
      }
    } catch (e) {
      log(
        "Exception in FirebaseAuthServices.createUserWithEmailAndPassword: $e",
      );

      throw CustomException("An Error occurred, please try again later.");
    }
  }

  @override
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        "Exception in FirebaseAuthServices.signInWithEmailAndPassword: $e & error code is ${e.code} & message is ${e.message} & stackTrace is ${e.stackTrace}",
      );
      if (e.code == 'invalid-credential') {
        throw CustomException('Wrong email or password.');
      } else if (e.code == 'invalid-email') {
        throw CustomException('Wrong email or password.');
      } else if (e.code == 'network-request-failed') {
        throw CustomException('No internet connection');
      } else {
        throw CustomException("An Error occurred, please try again later.");
      }
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      log("Exception in FirebaseAuthServices.deleteUser: $e");
      throw CustomException("An Error occurred, please try again later.");
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    return Future.value(FirebaseAuth.instance.currentUser);
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }
}
