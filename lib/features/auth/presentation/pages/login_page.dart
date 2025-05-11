// features/auth/presentation/pages/login_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/widgets/remember_me.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    context.read<AuthCubit>().validateForm(
          emailController.text,
          passwordController.text,
        );
    setState(() {});
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.auth_login_title.tr()),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.signInState is BaseErrorState) {
            final errorMessage =
                (state.signInState as BaseErrorState).errorMessage;
            GetIt.I<DialogUtils>().showSnackBar(
              message: errorMessage,
              textColor: AppColors.error,
              context: context,
            );
          } else if (state.signInState is BaseSuccessState) {
            Navigator.pushReplacementNamed(context, Routes.navbar);
          }
        },
        builder: (context, state) {
          final isFormValid = context.read<AuthCubit>().isFormValid;

          //----------------------------body----------------------------//
          return Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: emailController,
                    validator: Validator.emailValidate,
                    autofillHints: const [AutofillHints.email],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.auth_login_email_label.tr(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: LocaleKeys.auth_login_email_hint.tr(),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  ///password
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: Validator.passwordValidation,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.auth_login_password_label.tr(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: LocaleKeys.auth_login_password_hint.tr(),
                    ),
                  ),

                  //rememberMe -- forgotPassword
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ////rememberMe
                      const RememberMe(),

                      ///forgotPassword
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.forgetPassword,
                          );
                        },
                        child: Text(
                          LocaleKeys.auth_login_forgot_password.tr(),
                          style: getTextUnderLine(
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Spacer(flex: 2),

                  ///login button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFormValid
                          ? AppColors.primary
                          : AppColors.disableButton,
                    ),
                    onPressed: state.signInState is BaseLoadingState
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthCubit>().login(
                                    emailController.text.trim(),
                                    passwordController.text,
                                  );
                            }
                          },
                    child: state.signInState is BaseLoadingState
                        ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            LocaleKeys.auth_login_login_button.tr(),
                          ),
                  ),

                  Spacer(flex: 1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
