// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flowery_rider/core/services/image_picker_service.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
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
  const EditUserPersonalDataFormFields({
    super.key,
    required this.user,
    this.firstNameController,
    this.lastNameController,
    this.emailController,
    this.phoneController,
  });

  @override
  State<EditUserPersonalDataFormFields> createState() =>
      _EditUserPersonalDataFormState();
}

class _EditUserPersonalDataFormState
    extends State<EditUserPersonalDataFormFields> {
  @override
  void initState() {
    widget.firstNameController?.text = widget.user.userFname;
    widget.lastNameController?.text = widget.user.userLname;
    widget.emailController?.text = widget.user.userEmail;
    widget.phoneController?.text = widget.user.userPhone;
    super.initState();
  }

  final _imagePickerService = ImagePickerService();
  File? userProfilePhoto;
  bool isUserEditingProfilePhoto = false;

  Future<void> _pickImage(
    bool isUserProfilePhoto,
  ) async {
    final newFile = await _imagePickerService.pickImage(context);
    if (newFile == null) return;

    setState(() {
      if (isUserProfilePhoto) {
        userProfilePhoto = newFile;
        isUserEditingProfilePhoto = true;
        // _imagePickerService.addImageToCollection(
        //     newFile, _licensePhotos, (file) => _licensePhoto = file);
      } else {
        // _imagePickerService.addImageToCollection(
        //     newFile, _idPhotos, (file) => _idPhoto = file);
      }
    });
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
              child: isUserEditingProfilePhoto
                  ? CircleAvatar(
                      backgroundImage: FileImage(userProfilePhoto!),
                      radius: 40,
                    )
                  : AppNetworkImage(
                      networkImage:
                          userProfilePhoto?.path ?? widget.user.userImage ?? '',
                      width: 81,
                      height: 81,
                      borderRadius: BorderRadius.circular(100),
                      fit: BoxFit.cover,
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
                decoration: const InputDecoration(
                  labelText: 'First name',
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
                decoration: const InputDecoration(
                  labelText: 'Last name',
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
          decoration: const InputDecoration(
            labelText: 'Email',
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
          decoration: const InputDecoration(
            labelText: 'phone number',
          ),
        ),
        SizedBox(height: context.heightPercent(1.6)),
        TextFormField(
          // onTapOutside: (event) {
          //   FocusManager.instance.primaryFocus?.unfocus();
          // },
          readOnly: true,
          enabled: true,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'password',
            hintText: '********',
            suffix: GestureDetector(
              onTap: () {
                // Navigator.pushNamed(
                //     context, Routes.profileResetPassword);
              },
              child: Text(
                'Change',
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
