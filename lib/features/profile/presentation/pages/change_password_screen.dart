import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/utils/extensions.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_state.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/success_dilog.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ProfileCubit profileCubit;
  const ChangePasswordScreen({super.key, required this.profileCubit});

  @override
  Widget build(BuildContext context) {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.profile_change_password_title.tr()),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 24,
          ),
        ),
        titleSpacing: 0,
        leadingWidth: 35,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPercent(2.5),
          vertical: context.heightPercent(2),
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: currentPasswordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => Validator.passwordValidation(value),
                decoration: InputDecoration(
                  labelText: LocaleKeys
                      .profile_change_password_current_password_label
                      .tr(),
                  hintText: LocaleKeys
                      .profile_change_password_current_password_hint
                      .tr(),
                ),
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
              SizedBox(
                height: context.heightPercent(2),
              ),
              TextFormField(
                controller: newPasswordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => Validator.passwordValidation(value),
                decoration: InputDecoration(
                  labelText: LocaleKeys
                      .profile_change_password_new_password_label
                      .tr(),
                  hintText:
                      LocaleKeys.profile_change_password_new_password_hint.tr(),
                ),
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
              SizedBox(
                height: context.heightPercent(5.5),
              ),
              BlocListener<ProfileCubit, ProfileState>(
                listenWhen: (previous, current) =>
                    previous.changePassword != current.changePassword,
                listener: (context, state) {
                  state.changePassword.when(
                    initial: () {},
                    loading: () {
                      context.showLoadingIndicator();
                    },
                    success: (_) async {
                      context.hideLoadingIndicator();
                      context.read<ProfileCubit>().resetStates();
                      if (context.mounted) {
                        SuccessAnimationDialog.show(
                          context: context,
                          message: LocaleKeys
                              .profile_change_password_success_message
                              .tr(),
                          onDismissed: () {
                            Navigator.popUntil(
                              context,
                              (route) =>
                                  Routes.layoutScreen == route.settings.name,
                            );
                          },
                        );
                      }
                    },
                    error: (errorMessage) {
                      context.pop();
                      context.hideLoadingIndicator();
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          getIt<DialogUtils>().showSnackBar(
                            textColor: AppColors.error,
                            message: errorMessage,
                            context: context,
                          );
                        },
                      );
                    },
                  );
                },
                child: ElevatedButton(
                  onPressed: () {
                    _validateAndSubmit(
                      profileCubit,
                      currentPasswordController,
                      newPasswordController,
                      formKey,
                    );
                  },
                  child: Text(LocaleKeys.profile_change_password_button.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _validateAndSubmit(
    ProfileCubit profileCubit,
    TextEditingController currentPasswordController,
    TextEditingController newPasswordController,
    GlobalKey<FormState> formKey) {
  if (formKey.currentState!.validate()) {
    profileCubit.changePassword(
      oldPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
    );
  }
}
