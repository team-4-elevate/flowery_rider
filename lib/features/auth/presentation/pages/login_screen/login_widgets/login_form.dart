import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/features/auth/presentation/pages/login_screen/login_cubit.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> loginFormKey;
  final LoginCubit loginCubit; // Assuming you have a LoginCubit instance
  const LoginForm(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.loginFormKey,
      required this.loginCubit});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          TextFormField(
            validator: (email) => Validator.emailValidate(email),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: LocaleKeys.login_screen_email_label.tr(),
              hintText: LocaleKeys.login_screen_email_hint.tr(),
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          TextFormField(
            controller: passwordController,
            validator: (password) => Validator.passwordValidation(password),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            obscureText: true,
            obscuringCharacter: '*',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: LocaleKeys.login_screen_password_label.tr(),
              hintText: LocaleKeys.login_screen_password_hint.tr(),
            ),
          ),
          Row(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: loginCubit.rememberMe,
                builder: (context, value, child) {
                  return Checkbox(
                    activeColor: AppColors.primary,
                    value: value,
                    onChanged: (bool? value) {
                      loginCubit.changeRememberMe(value ?? false);
                    },
                  );
                },
              ),
              Text(LocaleKeys.login_screen_remember_me.tr()),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.black,
                  overlayColor: Colors.transparent,
                ),
                child: Text(
                  LocaleKeys.login_screen_forget_password.tr(),
                  style: const TextStyle(decoration: TextDecoration.underline),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
