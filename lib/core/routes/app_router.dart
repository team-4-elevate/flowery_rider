// core/routes/app_router.dart
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/features/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.onboarding:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const Onboarding(),
      );

    default:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}
