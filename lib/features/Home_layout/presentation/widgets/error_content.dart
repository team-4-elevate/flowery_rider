// features/Home_layout/presentation/widgets/error_content.dart
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class ErrorContent extends StatelessWidget {
  final String error;

  const ErrorContent({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.primary,
            size: 40.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            error,
            style: getMediumStyle(fontSize: 16.sp, color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            LocaleKeys.home_pull_to_refresh.tr(),
            style: getRegularStyle(fontSize: 14.sp, color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, Routes.login),
            child: Text(
              LocaleKeys.applicationApproved_login.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
