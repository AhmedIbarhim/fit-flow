import 'package:fit_flow/core/networking/database_service.dart';
import 'package:fit_flow/features/auth/domain/repos/auth_repo.dart';
import 'package:fit_flow/features/auth/presentation/controllers/login_controller/login_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repos/auth_repo_impl.dart';
import '../../features/auth/data/services/firebase_auth_service.dart';
import '../../features/auth/presentation/controllers/signup_controller/signup_cubit.dart';
import '../networking/authentication_service.dart';
import '../networking/firestore_service.dart';

final GetIt locator = GetIt.instance;

void initServiceLocator() {
  locator.registerSingleton<AuthenticationService>(FirebaseAuthService());

  locator.registerSingleton<DatabaseService>(FirestoreService());

  locator.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      authService: locator<AuthenticationService>(),
      databaseService: locator<DatabaseService>(),
    ),
  );

  locator.registerFactory<LoginCubit>(
    () => LoginCubit(authRepo: locator<AuthRepo>()),
  );

  locator.registerFactory<SignupCubit>(
    () => SignupCubit(authRepo: locator<AuthRepo>()),
  );
}
