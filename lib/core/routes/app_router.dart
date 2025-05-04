import 'package:flowery_rider/application_approved_page.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flutter/material.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.splash:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Splash Screen'),
          ),
        ),
      );
    case Routes.applicationApproved:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const ApplicationApprovedPage(),
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
