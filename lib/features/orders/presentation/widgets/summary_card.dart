// features/orders/presentation/widgets/summary_card.dart
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryCard extends StatelessWidget {
  final int count;
  final String status;
  final IconData statusIcon;
  final Color statusColor;
  final Color backgroundColor;

  const SummaryCard({
    super.key,
    required this.count,
    required this.status,
    required this.statusIcon,
    required this.statusColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: getBoldStyle(color: AppColors.black, fontSize: 20.sp),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 16.sp),
              SizedBox(width: 4.w),
              Text(
                status,
                style: getMediumStyle(color: statusColor, fontSize: 14.sp),
              ),
            ],
          ),
         
        ],
      ),
    );
  }
}
