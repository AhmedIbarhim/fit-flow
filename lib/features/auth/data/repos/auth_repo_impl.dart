import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_flow/core/networking/authentication_service.dart';
import 'package:fit_flow/core/networking/database_service.dart';
import 'package:fit_flow/core/networking/endpoints.dart';
import 'package:fit_flow/features/auth/data/models/user_model.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthenticationService authService;
  final DatabaseService databaseService;
  AuthRepoImpl({required this.authService, required this.databaseService});

  @override
  Future<void> addUserData(UserModel userModel) async {
    await databaseService.addData(
      path: Endpoints.usersPath,
      data: userModel.toJson(),
      docId: userModel.uId,
    );
  }

  @override
  Future<UserModel> getUserData({required String uId}) async {
    var userData = await databaseService.getData(
      path: Endpoints.usersPath,
      docId: uId,
    );
    return UserModel.fromJson(userData);
  }

  @override
  Future<Either<Failure, UserModel>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
  }) async {
    User? user;
    try {
      user = await authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        userName: userName,
      );
      UserModel userModel = UserModel(
        name: userName,
        email: email,
        uId: user.uid,
      );

      await addUserData(userModel);

      // return right(UserModel.fromFirebaseAuth(user));
      return right(userModel);
    } on CustomException catch (e) {
      if (user != null) {
        await authService.deleteUser();
      }
      return left(ServerFailure(e.exMessage));
    } catch (e) {
      log("Exception in AuthRepoImpl.createUserWithEmailAndPassword: $e");
      if (user != null) {
        // await authService.deleteUser();
      }
      return left(ServerFailure("An Error occurred, please try again later."));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(UserModel.fromFirebaseAuth(user));
    } on CustomException catch (e) {
      return left(ServerFailure(e.exMessage));
    } catch (e) {
      log("Exception in AuthRepoImpl.signInWithEmailAndPassword: $e");
      return left(ServerFailure("An Error occurred, please try again later."));
    }
  }
}
