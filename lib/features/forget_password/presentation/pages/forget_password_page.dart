import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/base/base_state.dart';
import '../../../../../core/di/injectable.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/utils/validator.dart';
import '../../../../../core/widget/dialog_utils.dart';
import '../cubit/forget_password_cubit.dart';
import '../cubit/forget_psasword_state.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController forgetEmailController;
  late final GlobalKey<FormState> forgetEmailFormKey;
  late final ForgetPasswordCubit forgetCubit;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    forgetEmailController = TextEditingController();
    forgetEmailFormKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    forgetCubit = context.read<ForgetPasswordCubit>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    forgetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: Column(
                  children: [
                    Text(
                      LocaleKeys.forgetPassword_title.tr(),
                      style: getMediumStyle(
                          color: AppColors.black, fontSize: 18.sp),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      LocaleKeys.forgetPassword_description.tr(),
                      textAlign: TextAlign.center,
                      style:
                          getLightStyle(color: AppColors.grey, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              Column(
                children: [
                  Form(
                    key: forgetEmailFormKey,
                    child: TextFormField(
                      controller: forgetEmailController,
                      validator: Validator.emailValidate,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.login_screen_email_label.tr(),
                        hintText: LocaleKeys.login_screen_email_hint.tr(),
                      ),
                    ),
                  ),
                  SizedBox(height: 48.h),
                  BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                    bloc: forgetCubit,
                    listenWhen: (previous, current) {
                      if (previous.forgetPasswordState is BaseLoadingState ||
                          current.forgetPasswordState is BaseLoadingState) {
                        return true;
                      }
                      return false;
                    },
                    listener: (context, state) {
                      if (state.forgetPasswordState is BaseSuccessState) {
                        Navigator.pushNamed(context, Routes.pinCode,
                            arguments: forgetCubit);
                      } else if (state.forgetPasswordState is BaseErrorState) {
                        final errorMessage =
                            (state.forgetPasswordState as BaseErrorState)
                                .errorMessage;
                        getIt<DialogUtils>().showSnackBar(
                            textColor: AppColors.error,
                            message: errorMessage,
                            context: context);
                      }
                    },
                    buildWhen: (previous, current) {
                      if (previous.forgetPasswordState is BaseLoadingState ||
                          current.forgetPasswordState is BaseLoadingState) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (state.forgetPasswordState is BaseLoadingState) {
                            return;
                          }
                          if (forgetEmailFormKey.currentState?.validate() ??
                              false) {
                            forgetCubit.forgetPassword(
                                forgetEmailController.text.trim());
                          } else {
                            null;
                          }
                        },
                        child: state.forgetPasswordState is BaseLoadingState
                            ? const CircularProgressIndicator(
                                color: AppColors.white)
                            : Text(
                                LocaleKeys.forgetPassword_continueButton.tr()),
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
