// features/Home_layout/presentation/widgets/address_card.dart
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressCard extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String title;
  final String address;
  final Widget? trailing;
  final bool showLocationIcon;

  const AddressCard({
    super.key,
    this.icon,
    this.imagePath,
    required this.title,
    required this.address,
    this.trailing,
    this.showLocationIcon = true,
  }) : assert(icon != null || imagePath != null,
            'Either icon or imagePath must be provided');

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
            color: AppColors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar (icon or image)
          _buildAvatar(),
          SizedBox(width: 12.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: getMediumStyle(
                        color: AppColors.black, fontSize: 14.sp)),
                SizedBox(height: 4.h),
                _buildAddressRow(),
              ],
            ),
          ),
          
          // Optional trailing widget
          if (trailing != null) ...[  
            SizedBox(width: 8.w),
            trailing!,
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 18.r,
      backgroundColor:
          imagePath != null ? Colors.transparent : AppColors.primary,
      child: imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Image.asset(imagePath!,
                  width: 36.r, height: 36.r, fit: BoxFit.cover),
            )
          : Icon(icon!, size: 18.sp, color: AppColors.white),
    );
  }

  Widget _buildAddressRow() {
    return Row(
      children: [
        if (showLocationIcon) ...[  
          Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.grey),
          SizedBox(width: 4.w),
        ],
        Expanded(
          child: Text(
            address,
            style: getRegularStyle(fontSize: 12.sp, color: AppColors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
