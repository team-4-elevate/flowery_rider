// features/auth/presentation/apply/widgets/upload_field.dart
import 'dart:io';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadField extends StatelessWidget {
  final String hintText;
  final File? file;
  final List<File>? files;
  final VoidCallback onTap;
  final Function(File)? onRemoveFile;
  final VoidCallback? onRemove;
  final String? label;

  const UploadField({
    super.key,
    required this.hintText,
    this.file,
    this.files,
    required this.onTap,
    this.onRemove,
    this.onRemoveFile,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final hasFiles = file != null || (files != null && files!.isNotEmpty);

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
          onTap: hasFiles ? null : onTap,
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.grey.withOpacity(0.02),
            ),
            child: hasFiles ? _buildFilesView(context) : _buildUploadPrompt(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilesView(BuildContext context) {
    List<File> filesToShow = [];
    if (file != null) {
      bool isDuplicate = false;
      if (files != null) {
        for (var f in files!) {
          if (f.path == file!.path) {
            isDuplicate = true;
            break;
          }
        }
      }
      if (!isDuplicate) filesToShow.add(file!);
    }
    if (files != null) filesToShow.addAll(files!);

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 8.w),
                ...filesToShow.map((f) => Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 2.w),
                      child: _buildImageThumbnail(f),
                    )),
              ],
            ),
          ),
        ),
        // Upload icon
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Icon(
              Icons.upload_file,
              color: AppColors.grey,
              size: 22.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageThumbnail(File imageFile) {
    return Container(
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Stack(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Delete button
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () {
                if (onRemoveFile != null) {
                  onRemoveFile!(imageFile);
                } else if (onRemove != null) {
                  onRemove!();
                }
              },
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 10.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadPrompt() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              hintText,
              style: getRegularStyle(
                fontSize: 14.sp,
                color: AppColors.grey,
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
    );
  }
}
