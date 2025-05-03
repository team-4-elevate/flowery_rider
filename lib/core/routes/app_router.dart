import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/features/Home_layout/home_layout.dart';
import 'package:flowery_rider/features/auth/presentation/pages/login_screen/login_screen.dart';
import 'package:flowery_rider/features/auth/presentation/pages/login_screen/login_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/pages/onboarding/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.onboarding:
      return MaterialPageRoute(
          settings: settings, builder: (_) => OnBoardingScreen());
    case Routes.login:
      return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
              create: (_) => getIt<LoginCubit>(), child: LoginScreen()));
    case Routes.homeLayout:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => HomeLayout(),
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
