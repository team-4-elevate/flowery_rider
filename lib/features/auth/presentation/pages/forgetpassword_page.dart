// features/auth/presentation/pages/forgetpassword_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flowery_rider/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetpasswordPage extends StatefulWidget {
  const ForgetpasswordPage({super.key});

  @override
  State<ForgetpasswordPage> createState() => _ForgetpasswordPageState();
}

class _ForgetpasswordPageState extends State<ForgetpasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.auth_forgot_password_title.tr()),
      ),

      // Body
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            previous.forgotPasswordState != current.forgotPasswordState,
        listener: (context, state) {
          if (state.forgotPasswordState is BaseLoadingState) {
            getIt<DialogUtils>().showLoading(context);
          } else {
            getIt<DialogUtils>().hideLoading(context);

            if (state.forgotPasswordState is BaseSuccessState) {
              // Navigate to OTP verification page, pass email as argument
              Navigator.pushNamed(
                context,
                Routes.emailVerification,
                arguments: _emailController.text,
              );

              // Reset the state to avoid going back to verification page
              context.read<AuthCubit>().resetForgotPasswordState();
            } else if (state.forgotPasswordState is BaseErrorState) {
              final errorState = state.forgotPasswordState as BaseErrorState;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorState.errorMessage)),
              );
            }
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      LocaleKeys.auth_forgot_password_heading.tr(),
                      style: getMediumStyle(
                        color: AppColors.black,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    LocaleKeys.auth_forgot_password_instruction.tr(),
                    style:
                        getLightStyle(color: AppColors.grey, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 32.h),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    validator: Validator.emailValidate,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText:
                          LocaleKeys.auth_forgot_password_email_label.tr(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: LocaleKeys.auth_forgot_password_email_hint.tr(),
                    ),
                  ),

                  SizedBox(height: 48.h),

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Request password reset
                          context.read<AuthCubit>().requestPasswordReset(
                                _emailController.text,
                              );
                        }
                      },
                      child: Text(
                          LocaleKeys.auth_forgot_password_confirm_button.tr()),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
