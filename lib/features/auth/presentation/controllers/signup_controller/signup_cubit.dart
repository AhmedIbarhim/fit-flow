import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_flow/features/auth/domain/repos/auth_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required this.authRepo}) : super(SignupInitial());

  final AuthRepo authRepo;

  Future<void> signup({
    required String email,
    required String password,
    required String userName,
  }) async {
    emit(SignupLoading());
    await authRepo
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
          userName: userName,
        )
        .then((value) {
          value.fold(
            (error) => emit(SignupFailure(error.errMessage)),
            (user) => emit(SignUpSuccess()),
          );
        });
  }
}
