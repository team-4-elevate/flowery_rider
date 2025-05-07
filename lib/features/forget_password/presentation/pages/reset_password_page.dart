import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/features/forget_password/presentation/cubit/forget_password_cubit.dart';
import 'package:flowery_rider/features/forget_password/presentation/cubit/forget_psasword_state.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/base/base_state.dart';
import '../../../../core/di/injectable.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widget/dialog_utils.dart';

class ResetPasswordPage extends StatelessWidget {
  final ForgetPasswordCubit forgetCubit;
  const ResetPasswordPage({super.key, required this.forgetCubit});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final forgetPasswordController = TextEditingController();
    final forgetConfirmPasswordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.login_screen_password_label.tr()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 16.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    Text(
                      LocaleKeys.reset_password_title.tr(),
                      style: getMediumStyle(
                          color: AppColors.black, fontSize: 18.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: forgetPasswordController,
                          validator: Validator.passwordValidation,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText:
                                LocaleKeys.login_screen_password_label.tr(),
                            hintText:
                                LocaleKeys.login_screen_password_hint.tr(),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        SizedBox(height: 24.h),
                        TextFormField(
                          controller: forgetConfirmPasswordController,
                          validator: (val) =>
                              Validator.confirmPasswordValidation(
                                  val, forgetPasswordController.text),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText:
                                LocaleKeys.reset_password_confirm_password.tr(),
                            hintText: LocaleKeys
                                .reset_password_confirm_password_hint
                                .tr(),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 48.h),
                  BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                    bloc: forgetCubit,
                    listener: (context, state) {
                      final utils = getIt<DialogUtils>();
                      if (state.resetPasswordState is BaseSuccessState) {
                        utils.showSnackBar(
                            textColor: Colors.green,
                            message:
                                LocaleKeys.reset_password_success_message.tr(),
                            context: context);
                        if (context.mounted) {
                          Navigator.popUntil(context,
                              (route) => route.settings.name == Routes.login);
                        }
                      } else if (state.resendOtpState is BaseErrorState) {
                        final errorMessage =
                            (state.resendOtpState as BaseErrorState)
                                .errorMessage;
                        utils.showSnackBar(
                            textColor: AppColors.error,
                            message: errorMessage,
                            context: context);
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (state.resetPasswordState is BaseLoadingState) {
                            return;
                          }
                          if (formKey.currentState?.validate() ?? false) {
                            await forgetCubit.resetPassword(
                              email: state.userEmail!,
                              newPassword: forgetPasswordController.text,
                            );
                          } else {
                            null;
                          }
                        },
                        child: state.resetPasswordState is BaseLoadingState
                            ? const CircularProgressIndicator(
                                color: AppColors.white)
                            : Text(LocaleKeys.login_screen_continue.tr()),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
