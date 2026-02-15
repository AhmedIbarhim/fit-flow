import 'package:flutter/material.dart';

import '../../features/startup/presentation/views/splash_view.dart';
import 'routes.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());

      default:
        return MaterialPageRoute(builder: (_) => const Placeholder());
    }
  }
}
