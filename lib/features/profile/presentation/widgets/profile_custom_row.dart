import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCustomRow extends StatelessWidget {
  const ProfileCustomRow({
    super.key,
    this.leftWidget,
    this.rightWidget,
    this.onTap,
    required this.title,
  });
  final Widget? leftWidget;
  final Widget? rightWidget;
  final VoidCallback? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      highlightColor: AppColors.primary[20],
      splashColor: AppColors.primary[10],
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
        child: Row(
          children: [
            leftWidget ?? const SizedBox.shrink(),
            const SizedBox(width: 4),
            Text(
              title,
              style: getRegularStyle(fontSize: 13.sp, color: AppColors.black),
            ),
            const Spacer(),
            rightWidget ??
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.grey,
                  size: 24,
                ),
          ],
        ),
      ),
    );
  }
}
