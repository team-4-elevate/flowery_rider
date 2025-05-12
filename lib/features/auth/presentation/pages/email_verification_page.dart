// features/auth/presentation/pages/email_verification_page.dart
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({
    required this.email,
    super.key,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();

  Timer? _timer;
  int _secondsRemaining = 60;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // Start countdown timer
  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _isResendEnabled = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  // Format seconds as MM:SS
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Helper function to mask email (e.g., s*****5@gmail.com)
  String maskEmail(String email) {
    if (email.isEmpty || !email.contains('@')) {
      return email;
    }

    final parts = email.split('@');
    final localPart = parts[0];
    final domainPart = parts[1];

    if (localPart.length <= 2) {
      return email;
    }

    final firstChar = localPart[0];
    final lastChar = localPart[localPart.length - 1];
    final starCount = localPart.length - 2;
    final stars = '*' * starCount;

    return '$firstChar$stars$lastChar@$domainPart';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.auth_verification_title.tr()),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            previous.verifyOtpState != current.verifyOtpState ||
            previous.forgotPasswordState != current.forgotPasswordState,
        listener: (context, state) {
          if (state.verifyOtpState is BaseLoadingState ||
              state.forgotPasswordState is BaseLoadingState) {
            getIt<DialogUtils>().showLoading(context);
          } else {
            getIt<DialogUtils>().hideLoading(context);

            if (state.verifyOtpState is BaseSuccessState) {
              Navigator.pushNamed(
                context,
                Routes.resetPassword,
                arguments: widget.email,
              );

              context.read<AuthCubit>().resetVerifyOtpState();
            } else if (state.verifyOtpState is BaseErrorState) {
              final errorState = state.verifyOtpState as BaseErrorState;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorState.errorMessage)),
              );
            }

            // Handle resend OTP response
            if (state.forgotPasswordState is BaseSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Verification code has been resent'),
                  backgroundColor: Colors.green,
                ),
              );
              // Restart timer after successful resend
              _startTimer();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Text(
                  LocaleKeys.auth_verification_heading.tr(),
                  style: getMediumStyle(
                    color: AppColors.black,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  LocaleKeys.auth_verification_instruction.tr(),
                  style: getLightStyle(color: AppColors.grey, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
                Text(
                  maskEmail(widget.email),
                  style: getMediumStyle(color: AppColors.grey, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),

                // OTP input field
                Pinput(
                  controller: _pinController,
                  focusNode: _pinFocusNode,
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onCompleted: (pin) {
                    context.read<AuthCubit>().verifyOtpCode(
                          widget.email,
                          pin,
                        );
                  },
                ),

                SizedBox(height: 32.h),

                // Resend button with timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code?",
                      style: getLightStyle(
                        color: AppColors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: _isResendEnabled
                          ? () {
                              context
                                  .read<AuthCubit>()
                                  .requestPasswordReset(widget.email);
                            }
                          : null,
                      child: _isResendEnabled
                          ? Text(
                              LocaleKeys.auth_verification_resend_button.tr())
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${LocaleKeys.auth_verification_resend_button.tr()} (${_formatTime(_secondsRemaining)})',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
