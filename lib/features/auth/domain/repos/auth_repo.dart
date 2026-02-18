import 'package:dartz/dartz.dart';
import 'package:fit_flow/features/auth/data/models/user_model.dart';

import '../../../../core/errors/failure.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
  });

  Future<void> addUserData(UserModel userModel);

  Future<UserModel> getUserData({required String uId});
}
