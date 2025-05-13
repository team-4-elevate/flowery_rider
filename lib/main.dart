import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flowery_rider/core/app_bloc_observer.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/routes/app_router.dart';
import 'package:flowery_rider/core/routes/navigator_observer.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/theme_data/theme_data_light.dart';
import 'package:flowery_rider/core/app_manger/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/Home_layout/presentation/cubit/home_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await _configureFirebase();
  await configureDependencies();
  Bloc.observer = AppBlocObserver();
  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MultiBlocProvider(providers: [
          BlocProvider(
            create: (context) => getIt<AppCubit>()..getUserLoggedInState(),
          ),
          BlocProvider(
            create: (context) => getIt<HomeCubit>(),
          ),
        ], child: const FloweryRider())),
  );
}

class FloweryRider extends StatelessWidget {
  const FloweryRider({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [getIt<AppNavigatorObserver>()],
        //initialRoute: Routes.login,
        initialRoute: context.read<AppCubit>().state.isLoggedIn
            ? Routes.layoutScreen
            : Routes.onboarding,
        onGenerateRoute: generateRoute,
        theme: getLightTheme(),
        darkTheme: ThemeData(),
        themeMode: ThemeMode.light,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}

Future<void> _configureFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
    return true;
  };
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
      fatal: true,
    );
  }).sendPort);
}
