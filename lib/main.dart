import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/app_bloc_observer.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/routes/app_router.dart';
import 'package:flowery_rider/core/routes/navigator_observer.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/theme_data/theme_data_light.dart';
import 'package:flowery_rider/features/Home_layout/cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureDependencies();
  Bloc.observer = AppBlocObserver();
  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: BlocProvider(
            create: (context) => getIt<AppCubit>(), child: FloweryRider())),
  );
}

class FloweryRider extends StatelessWidget {
  const FloweryRider({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AppCubit>().getUserLoggedInState();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [getIt<AppNavigatorObserver>()],
        //initialRoute: Routes.login,
        initialRoute: context.read<AppCubit>().state.isLoggedIn
            ? Routes.homeLayout
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
