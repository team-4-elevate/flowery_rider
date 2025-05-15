// features/orders/presentation/widgets/order_card.dart
import 'package:flowery_rider/core/common/widgets/address_card.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String status;
  final bool isCompleted;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.status,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withAlpha(40),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Flower order',
                  style:
                      getMediumStyle(color: AppColors.black, fontSize: 14.sp),
                ),
                Text(
                  '# $orderNumber',
                  style:
                      getMediumStyle(color: AppColors.black, fontSize: 14.sp),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(
                  isCompleted ? Icons.check_circle : Icons.cancel,
                  color: isCompleted ? AppColors.success : AppColors.error,
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  status,
                  style: getMediumStyle(
                    color: isCompleted ? AppColors.success : AppColors.error,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pickup address',
                  style:
                      getRegularStyle(color: AppColors.grey, fontSize: 12.sp),
                ),
                SizedBox(height: 8.h),
                AddressCard(
                  title: 'Flowery store',
                  address: '20th st, Sheikh Zayed, Giza',
                  icon: Icons.store,
                ),
                SizedBox(height: 16.h),
                Text(
                  'User address',
                  style:
                      getRegularStyle(color: AppColors.grey, fontSize: 12.sp),
                ),
                SizedBox(height: 8.h),
                AddressCard(
                  title: 'Nour mohamed',
                  address: '20th st, Sheikh Zayed, Giza',
                  icon: Icons.person,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
