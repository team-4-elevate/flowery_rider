import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/auth/presentation/pages/login_screen/login_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/pages/login_screen/login_states.dart';
import 'package:flowery_rider/features/auth/presentation/pages/login_screen/login_widgets/login_form.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          LocaleKeys.login_screen_login.tr(),
        ),
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
        leadingWidth: 30.w,
      ),
      body: Builder(
        builder: (context) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return Stack(
            children: <Widget>[
              ListView(
                padding: EdgeInsets.only(bottom: 150.h + keyboardHeight),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: LoginForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      loginFormKey: formKey,
                      loginCubit: context.read<LoginCubit>(),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: keyboardHeight > 0 ? keyboardHeight : 50.h,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: BlocListener<LoginCubit, LoginStates>(
                    listener: (context, state) {
                      if (state.loginStates is BaseSuccessState) {
                        _showDoneDialog(context);
                      }
                      if (state.loginStates is BaseErrorState) {
                        Navigator.of(context).pop();
                        getIt<DialogUtils>().showErrorDialog(
                          context,
                          LocaleKeys.login_screen_authentication_failed.tr(),
                          (state.loginStates as BaseErrorState).errorMessage,
                        );
                      }
                      if (state.loginStates is BaseLoadingState) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            backgroundColor: Colors.transparent,
                            content: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        _validateThenDoLogin(
                          formKey: formKey,
                          context: context,
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      },
                      child: Text(
                        LocaleKeys.login_screen_login.tr(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void _showDoneDialog(BuildContext context) {
  Navigator.of(context).pop();
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.white.withAlpha(204),
      content: Lottie.asset(
        'assets/ainmations/sucess_animation.json',
        repeat: false,
        height: 150.h,
        width: 150.w,
        fit: BoxFit.contain,
        onLoaded: (composition) {
          Future.delayed(
            composition.duration + const Duration(milliseconds: 200),
            () {
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed(Routes.homeLayout);
              }
            },
          );
        },
      ),
    ),
  );
}

void _validateThenDoLogin({
  required GlobalKey<FormState> formKey,
  required BuildContext context,
  required String email,
  required String password,
}) {
  if (formKey.currentState?.validate() ?? false) {
    context.read<LoginCubit>().doLogin(email, password);
  }
}
