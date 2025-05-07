// core/routes/app_router.dart
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/pages/apply_page.dart';
import 'package:flowery_rider/features/auth/presentation/pages/apply_success_page.dart';
import 'package:flowery_rider/features/auth/presentation/pages/email_verification_page.dart';
import 'package:flowery_rider/features/auth/presentation/pages/forgetpassword_page.dart';
import 'package:flowery_rider/features/auth/presentation/pages/login_page.dart';
import 'package:flowery_rider/features/auth/presentation/pages/resetpassword_page.dart';
import 'package:flowery_rider/features/home/home.dart';
import 'package:flowery_rider/features/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.onboarding:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const Onboarding(),
      );

    case Routes.login:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: const LoginPage(),
        ),
      );

    case Routes.apply:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: const ApplyPage(),
        ),
      );

    case Routes.successApply:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const ApplySuccessPage(),
      );

    case Routes.forgetPassword:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: const ForgetpasswordPage(),
        ),
      );

    case Routes.emailVerification:
      final String email = settings.arguments as String;
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: EmailVerificationPage(email: email),
        ),
      );

    case Routes.resetPassword:
      final String email = settings.arguments as String;
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: ResetpasswordPage(email: email),
        ),
      );

    case Routes.home:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const Home(),
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
