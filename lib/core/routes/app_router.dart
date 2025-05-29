// core/routes/app_router.dart
import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/application_approved_page.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/apply/cubit/auth_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/apply/pages/apply_page.dart';
import 'package:flowery_rider/features/auth/presentation/apply/pages/apply_success_page.dart';
import 'package:flowery_rider/features/auth/presentation/login_screen/login_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/login_screen/login_screen.dart';
import 'package:flowery_rider/features/forget_password/presentation/cubit/forget_password_cubit.dart';
import 'package:flowery_rider/features/forget_password/presentation/pages/forget_password_page.dart'
    show ForgetPasswordPage;
import 'package:flowery_rider/features/forget_password/presentation/pages/pin_code_page.dart';
import 'package:flowery_rider/features/forget_password/presentation/pages/reset_password_page.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flowery_rider/features/profile/presentation/pages/change_password_screen.dart';
import 'package:flowery_rider/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:flowery_rider/features/order_details/presentation/order_details_page/order_details_page.dart';
import 'package:flowery_rider/features/orders/presentation/pages/completed_orders_details.dart';
import 'package:flowery_rider/features/orders/presentation/pages/orders_screen.dart';
import 'package:flowery_rider/features/orders/domain/usecase/order_usecase.dart';
import 'package:flowery_rider/features/success-screen/order_success.dart';

import 'package:flowery_rider/features/main_layout/cubit/layout_cubit.dart';
import 'package:flowery_rider/features/main_layout/screen/layout_screen.dart';
import 'package:flowery_rider/features/onboarding/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.onboarding:
      return MaterialPageRoute(
          settings: settings, builder: (_) => Onboarding());
    case Routes.login:
      return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
              create: (_) => getIt<LoginCubit>(), child: LoginScreen()));
    case Routes.layoutScreen:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<HomeCubit>(),
            )
          ],
          child: BlocProvider(
              create: (context) => getIt<LayoutCubit>(), child: LayoutScreen()),
        ),
      );
    case Routes.applicationApproved:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const ApplicationApprovedPage(),
      );
    case Routes.forgetPassword:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) {
          return BlocProvider(
              create: (context) => getIt<ForgetPasswordCubit>(),
              child: ForgetPasswordPage());
        },
      );
    case Routes.pinCode:
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            final args = settings.arguments as ForgetPasswordCubit;
            return BlocProvider.value(
                value: args, child: PinCodePage(forgetPasswordCubit: args));
          });
    case Routes.resetPassword:
      return MaterialPageRoute(
          settings: settings,
          builder: (con) {
            final args = settings.arguments as ForgetPasswordCubit;
            return BlocProvider.value(
                value: args,
                child: ResetPasswordPage(
                  forgetCubit: args,
                ));
          });

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

    case Routes.successorder:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => SuccessOrderPage(),
      );
    case Routes.editProfile:
      final args = settings.arguments as Map<String, dynamic>;
      final userData = args['userData'] as UserDataEntity;
      final isEditUserData = args['isEditUserData'] as bool;
      final profileCubit = args['profileCubit'] as ProfileCubit;
      return MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: profileCubit,
          child: EditProfileScreen(
              userdata: userData, isEditUserData: isEditUserData),
        ),
      );
    case Routes.changePassword:
      var cubit = settings.arguments as ProfileCubit;
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: cubit,
                child: ChangePasswordScreen(
                  profileCubit: cubit,
                ),
              ));
    case Routes.orderDetails:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) {
          final args = settings.arguments as DriverOrderModel;
          return BlocProvider.value(
              value: getIt<HomeCubit>(), child: OrderDetailsPage(order: args));
        },
      );
    case Routes.ordersScreen:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          final driverId = settings.arguments as String?;
          if (driverId != null) {
            return OrdersScreen(driverId: driverId);
          }

          return FutureBuilder<String?>(
            future: getIt<OdersUsecase>().execute(),
            builder: (context, snapshot) =>
                OrdersScreen(driverId: snapshot.data),
          );
        },
      );

    case Routes.completedDetailsScreen:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const CompletedOrdersDetails(),
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
