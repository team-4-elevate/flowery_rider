// features/Home_layout/presentation/widgets/address_card.dart
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String address;

  const AddressCard({
    super.key,
    required this.icon,
    required this.title,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(
              AppColors.grey.r.toInt(),
              AppColors.grey.g.toInt(),
              AppColors.grey.b.toInt(),
              0.2,
            ),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Icon
          CircleAvatar(
            radius: 18.r,
            child: Icon(
              icon,
              size: 18.sp,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: 12.w),

          /// Address details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //// Title
                Text(
                  title,
                  style: getMediumStyle(
                    color: AppColors.black,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),

                //// location of order
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14.sp,
                      color: AppColors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        address,
                        style: getRegularStyle(
                          fontSize: 12.sp,
                          color: AppColors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
