import 'package:fit_flow/core/networking/database_service.dart';
import 'package:fit_flow/features/auth/domain/repos/auth_repo.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repos/auth_repo_impl.dart';
import '../../features/auth/data/services/firebase_auth_service.dart';
import '../networking/authentication_service.dart';
import '../networking/firestore_service.dart';

class ServiceLocator {
  static final GetIt locator = GetIt.instance;

  static void init() {
    locator.registerSingleton<AuthenticationService>(FirebaseAuthService());

    locator.registerSingleton<DatabaseService>(FirestoreService());

    locator.registerSingleton<AuthRepo>(
      AuthRepoImpl(
        authService: locator<AuthenticationService>(),
        databaseService: locator<DatabaseService>(),
      ),
    );
  }
}
