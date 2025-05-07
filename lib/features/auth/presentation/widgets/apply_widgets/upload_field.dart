// features/auth/presentation/widgets/apply_widgets/upload_field.dart
import 'dart:io';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class UploadField extends StatelessWidget {
  final String hintText;
  final File? file;
  final VoidCallback onTap;
  final String? label;

  const UploadField({
    super.key,
    required this.hintText,
    required this.file,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: getRegularStyle(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 5.h),
        ],
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      file != null
                          ? LocaleKeys.auth_apply_file_uploaded.tr()
                          : hintText,
                      style: getRegularStyle(
                        fontSize: 14.sp,
                        color: file != null ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Icon(
                    Icons.upload_file,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
