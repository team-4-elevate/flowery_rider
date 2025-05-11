// features/Home_layout/presentation/widgets/order_content.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_icons.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/common/widgets/address_card.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
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
            LocaleKeys.home_flower_order.tr(),
            style: getBoldStyle(
              fontSize: 16.sp,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            LocaleKeys.home_pickup_address.tr(),
            style: getRegularStyle(
              fontSize: 14.sp,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 8.h),
          AddressCard(
            imagePath: AppIcons.flowerImg,
            title: LocaleKeys.home_flowery_store.tr(),
            address: storeAddress,
          ),
          SizedBox(height: 12.h),
          Text(
            LocaleKeys.home_user_address.tr(),
            style: getRegularStyle(
              fontSize: 14.sp,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 8.h),

          /// User address
          AddressCard(
            imagePath: AppIcons.userImg,
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
                  price > 0 ? '${LocaleKeys.home_currency.tr()} ${price.toStringAsFixed(0)}' : '${LocaleKeys.home_currency.tr()} 0',
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
                    LocaleKeys.home_reject.tr(),
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
                    LocaleKeys.home_accept.tr(),
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
