// features/orders/presentation/pages/completed_orders_details.dart
import 'package:flowery_rider/core/widget/address_card.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/features/orders/presentation/widgets/info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompletedOrdersDetails extends StatelessWidget {
  const CompletedOrdersDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('Order details'),
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status and Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.success,
                      size: 20.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Completed',
                      style: getMediumStyle(
                        color: AppColors.success,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                Text(
                  '# 123456',
                  style:
                      getMediumStyle(color: AppColors.black, fontSize: 16.sp),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            //------------------------------------------------ Pickup Address
            Text(
              'Pickup address',
              style: getRegularStyle(color: AppColors.grey, fontSize: 12.sp),
            ),
            SizedBox(height: 8.h),
            AddressCard(
              title: 'Flowery store',
              address: '20th st, Sheikh Zayed, Giza',
              icon: Icons.store,
            ),
            SizedBox(height: 16.h),

            // //------------------------------------------------ User Address
            Text(
              'User address',
              style: getRegularStyle(color: AppColors.grey, fontSize: 12.sp),
            ),
            SizedBox(height: 8.h),
            AddressCard(
              title: 'Nour mohamed',
              address: '20th st, Sheikh Zayed, Giza',
              icon: Icons.person,
            ),
            SizedBox(height: 24.h),

            ////------------------------------------------------ Order Details
            Text(
              'Order details',
              style: getBoldStyle(color: AppColors.black, fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),

            // //------------------------------------------------Product Items
            AddressCard(
              title: 'Red roses,15 Pink Rose Bouquet',
              address: 'EGP 600',
              icon: Icons.local_florist,
              showLocationIcon: false,
              trailing: Text(
                'x1',
                style:
                    getMediumStyle(color: AppColors.primary, fontSize: 14.sp),
              ),
            ),
            SizedBox(height: 8.h),
            AddressCard(
              title: 'Red roses,15 Pink Rose Bouquet',
              address: 'EGP 600',
              icon: Icons.local_florist,
              showLocationIcon: false,
              trailing: Text(
                'x1',
                style:
                    getMediumStyle(color: AppColors.primary, fontSize: 14.sp),
              ),
            ),
            SizedBox(height: 24.h),

            // Total Section
            InfoRow(label: 'Total', value: 'Egp 3000'),
            SizedBox(height: 20.h),

            // Payment Method
            InfoRow(label: 'Payment method', value: 'Cash on delivery'),
          ],
        ),
      ),
    );
  }
}
