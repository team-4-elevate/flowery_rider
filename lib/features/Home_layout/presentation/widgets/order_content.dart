// features/Home_layout/presentation/widgets/order_content.dart
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/features/Home_layout/presentation/widgets/address_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderContent extends StatelessWidget {
  final String storeAddress;
  final String userName;
  final String userAddress;
  final double price;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const OrderContent({
    super.key,
    required this.storeAddress,
    required this.userName,
    required this.userAddress,
    required this.price,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(
              AppColors.grey.r.toInt(),
              AppColors.grey.g.toInt(),
              AppColors.grey.b.toInt(),
              0.1,
            ),
            blurRadius: 10,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Order title
          Text(
            'Flower order',
            style: getBoldStyle(
              fontSize: 16.sp,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Pickup address',
            style: getRegularStyle(
              fontSize: 14.sp,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 8.h),
          AddressCard(
            icon: Icons.store,
            title: 'Flowery store',
            address: storeAddress,
          ),
          SizedBox(height: 12.h),
          Text(
            'User address',
            style: getRegularStyle(
              fontSize: 14.sp,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 8.h),

          /// User address
          AddressCard(
            icon: Icons.person,
            title: userName,
            address: userAddress,
          ),
          SizedBox(height: 16.h),

          /// Price and buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                //// Price
                child: Text(
                  'EGP ${price.toStringAsFixed(0)}',
                  style: getBoldStyle(
                    fontSize: 16.sp,
                    color: AppColors.black,
                  ),
                ),
              ),
              //// reject button
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 36.h),
                  ),
                  child: Text(
                    'Reject',
                    style: getMediumStyle(
                      fontSize: 14.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              //// accept button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 36.h),
                  ),
                  child: Text(
                    'Accept',
                    style: getMediumStyle(
                      fontSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
