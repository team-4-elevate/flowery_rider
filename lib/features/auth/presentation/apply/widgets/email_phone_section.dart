// features/auth/presentation/apply/widgets/email_phone_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';

class EmailPhoneSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const EmailPhoneSection({
    super.key,
    required this.emailController,
    required this.phoneController,
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
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.auth_apply_email_hint.tr(),
            labelText: LocaleKeys.auth_apply_email.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: emailController,
          validator: Validator.emailValidate,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 15.h),
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.auth_apply_phone_number_hint.tr(),
            labelText: LocaleKeys.auth_apply_phone_number.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: phoneController,
          validator: Validator.phoneNumberValidation,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ],
    );
  }
}
