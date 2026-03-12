import 'package:fit_flow/core/di/service_locator.dart';
import 'package:fit_flow/features/auth/domain/repos/auth_repo.dart';
import 'package:fit_flow/features/auth/presentation/controllers/login_controller/login_cubit.dart';
import 'package:fit_flow/features/auth/presentation/controllers/signup_controller/signup_cubit.dart';
import 'package:fit_flow/features/auth/presentation/views/login_view.dart';
import 'package:fit_flow/features/auth/presentation/views/signup_view.dart';
import 'package:fit_flow/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/startup/splash_view.dart';
import 'routes.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());

      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(authRepo: locator<AuthRepo>()),
            child: const LoginView(),
          ),
        );

      case Routes.signup:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SignupCubit(authRepo: locator<AuthRepo>()),
            child: const SignupView(),
          ),
        );

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeView());

      default:
        return MaterialPageRoute(builder: (_) => const Placeholder());
    }
  }
}
