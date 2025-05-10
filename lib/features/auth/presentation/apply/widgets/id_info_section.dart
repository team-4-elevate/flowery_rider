// features/auth/presentation/apply/widgets/id_info_section.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/upload_field.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';

class IdInfoSection extends StatelessWidget {
  final TextEditingController idNumberController;
  final File? idPhoto;
  final List<File> idPhotos;
  final VoidCallback onPickIdPhoto;
  final VoidCallback onRemoveIdPhoto;
  final Function(File) onRemoveSpecificIdPhoto;

  const IdInfoSection({
    super.key,
    required this.idNumberController,
    required this.idPhoto,
    required this.idPhotos,
    required this.onPickIdPhoto,
    required this.onRemoveIdPhoto,
    required this.onRemoveSpecificIdPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.auth_apply_id_number.tr(),
          style: getMediumStyle(
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 15.h),
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.auth_apply_id_hint.tr(),
            labelText: LocaleKeys.auth_apply_id_number.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: idNumberController,
          validator: Validator.validateRequired,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 15.h),
        UploadField(
          label: LocaleKeys.auth_apply_id_docs.tr(),
          hintText: LocaleKeys.auth_apply_id_image_hint.tr(),
          file: idPhoto,
          files: idPhotos,
          onTap: onPickIdPhoto,
          onRemove: onRemoveIdPhoto,
          onRemoveFile: onRemoveSpecificIdPhoto,
        ),
      ],
    );
  }
}
