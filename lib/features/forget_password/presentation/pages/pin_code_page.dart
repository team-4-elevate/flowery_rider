import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/forget_password/presentation/cubit/forget_psasword_state.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:otp_resend_timer/otp_resend_timer.dart';
import '../../../../../core/base/base_state.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../cubit/forget_password_cubit.dart';

class PinCodePage extends StatelessWidget {
  final ForgetPasswordCubit forgetPasswordCubit;
  const PinCodePage({super.key, required this.forgetPasswordCubit});

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.reset_password_title.tr())),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 16.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Column(
                children: [
                  Text(
                    LocaleKeys.pinCode_title.tr(),
                    style:
                        getMediumStyle(color: AppColors.black, fontSize: 18.sp),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    LocaleKeys.pinCode_description.tr(),
                    textAlign: TextAlign.center,
                    style:
                        getLightStyle(color: AppColors.grey, fontSize: 14.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
              listenWhen: (p, c) =>
                  p.resendOtpState != c.resendOtpState ||
                  p.verifyResetCodeState != c.verifyResetCodeState,
              listener: (context, state) {
                if (state.verifyResetCodeState is BaseSuccessState) {
                  Navigator.pushNamed(context, Routes.resetPassword,
                      arguments: forgetPasswordCubit);
                } else if (state.verifyResetCodeState is BaseErrorState) {
                  pinController.clear();
                }
                if (state.resendOtpState is BaseSuccessState) {
                  getIt<DialogUtils>().showSnackBar(
                      textColor: Colors.green,
                      message: LocaleKeys.pinCode_otpSent.tr(),
                      context: context);
                }
              },
              buildWhen: (previous, current) {
                if (previous.verifyResetCodeState is BaseLoadingState ||
                    current.verifyResetCodeState is BaseLoadingState) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                final hasError = state.verifyResetCodeState is BaseErrorState;
                final errorMessage = hasError
                    ? (state.verifyResetCodeState as BaseErrorState)
                        .errorMessage
                    : null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Pinput(
                      length: 6,
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      showCursor: true,
                      pinAnimationType: PinAnimationType.fade,
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      defaultPinTheme:
                          hasError ? _errorPinTheme() : _pinTheme(),
                      focusedPinTheme: _focusedPinTheme(),
                      submittedPinTheme: _focusedPinTheme(),
                      onCompleted: (pin) {
                        forgetPasswordCubit.verifyResetCode(pin);
                        pinController.clear();
                      },
                    ),
                    if (hasError)
                      Padding(
                        padding: EdgeInsetsDirectional.only(top: 8.h, end: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppColors.error, size: 18),
                            SizedBox(width: 4.w),
                            Text(
                              errorMessage ??
                                  LocaleKeys.pinCode_ErrorMessage.tr(),
                              style: getLightStyle(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: 24.h),
            Center(
              child: OtpResendTimer(
                controller: OtpResendTimerController(initialTime: 60),
                onResendClicked: () async {
                  pinController.clear();
                  await forgetPasswordCubit.resendOtp();
                },
                autoStart: true,
                readyMessage: LocaleKeys.pinCode_ReadyMessage.tr(),
                resendMessage: LocaleKeys.pinCode_ResendMessage.tr(),
                timerMessageStyle:
                    getMediumStyle(color: AppColors.primary, fontSize: 12.sp),
                resendMessageStyle:
                    getRegularStyle(color: AppColors.primary, fontSize: 16.sp),
                readyMessageStyle:
                    getRegularStyle(color: AppColors.black, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PinTheme _pinTheme() => PinTheme(
        width: 50.w,
        height: 50.h,
        textStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        decoration: BoxDecoration(
          color: AppColors.disableButton,
          borderRadius: BorderRadius.circular(10),
        ),
      );

  PinTheme _focusedPinTheme() => PinTheme(
        width: 50.w,
        height: 50.h,
        textStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
      );

  PinTheme _errorPinTheme() => PinTheme(
        width: 50.w,
        height: 50.h,
        textStyle: TextStyle(
            fontSize: 20.sp,
            color: AppColors.error,
            fontWeight: FontWeight.bold),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.error, width: 1),
        ),
      );
}
