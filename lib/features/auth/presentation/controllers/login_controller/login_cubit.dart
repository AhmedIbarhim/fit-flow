import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_flow/features/auth/data/models/user_model.dart';
import 'package:fit_flow/features/auth/domain/repos/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authRepo}) : super(LoginInitial());

  final AuthRepo authRepo;

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    await authRepo
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          value.fold(
            (error) => emit(LoginFailure(error.errMessage)),
            (user) => emit(LoginSuccess(user: user)),
          );
        });
  }
}
