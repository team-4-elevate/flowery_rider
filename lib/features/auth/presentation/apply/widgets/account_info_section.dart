// features/auth/presentation/apply/widgets/account_info_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';

class AccountInfoSection extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const AccountInfoSection({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.auth_apply_account_information.tr(),
          style: getMediumStyle(
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 15.h),

        /// Password
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: LocaleKeys.auth_apply_password_hint.tr(),
                  labelText: LocaleKeys.auth_apply_password.tr(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: passwordController,
                validator: Validator.passwordValidation,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            SizedBox(width: 10.w),

            /// Confirm Password
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: LocaleKeys.auth_apply_confirm_password_hint.tr(),
                  labelText: LocaleKeys.auth_apply_confirm_password.tr(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: confirmPasswordController,
                validator: (value) => Validator.confirmPasswordValidation(
                    value, passwordController.text),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
