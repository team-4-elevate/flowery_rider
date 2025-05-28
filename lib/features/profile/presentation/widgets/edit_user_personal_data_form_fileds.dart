// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/services/image_picker_service.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/extensions.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/core/widget/app_network_image.dart';

class EditUserPersonalDataFormFields extends StatefulWidget {
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? emailController;
  final TextEditingController? phoneController;
  final UserDataEntity user;
  final ProfileCubit profileCubit;
  const EditUserPersonalDataFormFields({
    super.key,
    required this.user,
    this.firstNameController,
    this.lastNameController,
    this.emailController,
    this.phoneController,
    required this.profileCubit,
  });

  @override
  State<EditUserPersonalDataFormFields> createState() =>
      _EditUserPersonalDataFormState();
}

class _EditUserPersonalDataFormState
    extends State<EditUserPersonalDataFormFields> {
  final _imagePickerService = ImagePickerService();

  @override
  void initState() {
    widget.firstNameController?.text = widget.user.userFname;
    widget.lastNameController?.text = widget.user.userLname;
    widget.emailController?.text = widget.user.userEmail;
    String phoneNumber = widget.user.userPhone;
    widget.phoneController?.text =
        phoneNumber.startsWith('+2') ? phoneNumber.substring(2) : phoneNumber;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage(bool isUserProfilePhoto) async {
    final newFile = await _imagePickerService.pickImage(context);
    if (newFile == null) return;

    if (isUserProfilePhoto) {
      isUserProfilePhoto = true;
      widget.profileCubit.userProfileImage.value = newFile;
    } else {
      widget.profileCubit.userProfileImage.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: () {
                _pickImage(true);
              },
              child: ValueListenableBuilder<File?>(
                valueListenable: widget.profileCubit.userProfileImage,
                builder: (context, userProfilePhoto, child) {
                  return userProfilePhoto != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(userProfilePhoto),
                          radius: 50,
                        )
                      : AppNetworkImage(
                          networkImage: widget.user.userImage ?? '',
                          width: 81,
                          height: 81,
                          borderRadius: BorderRadius.circular(100),
                          fit: BoxFit.cover,
                        );
                },
              ),
            ),
          ),
        ),
        SizedBox(height: context.heightPercent(2.4)),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.firstNameController,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => Validator.firstNameValidation(value),
                decoration: InputDecoration(
                  labelText: LocaleKeys
                      .profile_edit_profile_user_info_form_first_name
                      .tr(),
                ),
              ),
            ),
            SizedBox(width: context.widthPercent(3)),
            Expanded(
              child: TextFormField(
                controller: widget.lastNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                validator: (value) => Validator.firstNameValidation(value),
                decoration: InputDecoration(
                  labelText: LocaleKeys
                      .profile_edit_profile_user_info_form_last_name
                      .tr(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.heightPercent(1.6)),
        TextFormField(
          controller: widget.emailController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          validator: (value) => Validator.emailValidate(value),
          decoration: InputDecoration(
            labelText:
                LocaleKeys.profile_edit_profile_user_info_form_email.tr(),
          ),
        ),
        SizedBox(height: context.heightPercent(1.6)),
        TextFormField(
          controller: widget.phoneController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          validator: (value) => Validator.phoneNumberValidation(value),
          decoration: InputDecoration(
            labelText:
                LocaleKeys.profile_edit_profile_user_info_form_phone.tr(),
          ),
        ),
        SizedBox(height: context.heightPercent(1.6)),
        TextFormField(
          readOnly: true,
          enabled: true,
          autofocus: true,
          decoration: InputDecoration(
            labelText:
                LocaleKeys.profile_edit_profile_user_info_form_password.tr(),
            hintText: '********',
            suffix: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.changePassword,
                    arguments: widget.profileCubit);
              },
              child: Text(
                LocaleKeys.profile_edit_profile_user_info_form_change_button
                    .tr(),
                style: getBoldStyle(color: AppColors.primary, fontSize: 12)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
