// features/auth/presentation/apply/widgets/personal_info_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';

class PersonalInfoSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const PersonalInfoSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.apply_account_information.tr(),
          style: getMediumStyle(
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 15.h),

        /// First Name
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.apply_first_name_hint.tr(),
            labelText: LocaleKeys.apply_first_name.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: firstNameController,
          validator: Validator.firstNameValidation,
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 15.h),

        /// Last Name
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.apply_last_name_hint.tr(),
            labelText: LocaleKeys.apply_last_name.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: lastNameController,
          validator: Validator.lastNameValidation,
          keyboardType: TextInputType.name,
        ),
      ],
    );
  }
}
