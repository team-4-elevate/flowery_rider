// features/auth/presentation/pages/resetpassword_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetpasswordPage extends StatefulWidget {
  final String email;

  const ResetpasswordPage({
    required this.email,
    super.key,
  });

  @override
  State<ResetpasswordPage> createState() => _ResetpasswordPageState();
}

class _ResetpasswordPageState extends State<ResetpasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.auth_resetpassword_title.tr()),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            previous.resetPasswordState != current.resetPasswordState,
        listener: (context, state) {
          if (state.resetPasswordState is BaseLoadingState) {
            getIt<DialogUtils>().showLoading(context);
          } else {
            getIt<DialogUtils>().hideLoading(context);

            if (state.resetPasswordState is BaseSuccessState) {
              getIt<DialogUtils>().showSnackBar(
                textColor: Colors.white,
                message: LocaleKeys.auth_resetpassword_success.tr(),
                context: context,
                duration: const Duration(seconds: 2),
              );

              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.home,
                (route) => false,
              );

              context.read<AuthCubit>().resetPasswordResetState();
            } else if (state.resetPasswordState is BaseErrorState) {
              final errorState = state.resetPasswordState as BaseErrorState;
              getIt<DialogUtils>().showSnackBar(
                textColor: Colors.white,
                message: errorState.errorMessage,
                context: context,
                duration: const Duration(seconds: 2),
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
                      LocaleKeys.auth_resetpassword_heading.tr(),
                      style: getMediumStyle(
                        color: AppColors.black,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    LocaleKeys.auth_resetpassword_instruction.tr(),
                    style:
                        getLightStyle(color: AppColors.grey, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 40.h),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    validator: Validator.passwordValidation,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.auth_login_password_label.tr(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: LocaleKeys.auth_login_password_hint.tr(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Confirm password field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return LocaleKeys.validation_passwordMatch.tr();
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText:
                          LocaleKeys.auth_resetpassword_confirm_label.tr(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: LocaleKeys.auth_resetpassword_confirm_hint.tr(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 48.h),

                  // Reset Password button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Reset password
                          context.read<AuthCubit>().resetPassword(
                                widget.email,
                                _passwordController.text,
                                _confirmPasswordController.text,
                              );
                        }
                      },
                      child: Text(LocaleKeys.auth_resetpassword_button.tr()),
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
