// features/order_details/presentation/widgets/order_details_address_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widget/address_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_styles.dart';

class OrderDetailsAddressWidget extends StatelessWidget {
  final String title;
  final String address;
  final bool isStore;
  final String? userName;

  const OrderDetailsAddressWidget({
    super.key,
    required this.title,
    required this.address,
    this.isStore = false,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getRegularStyle(
            fontSize: 14.sp,
            color: AppColors.grey,
          ),
        ),
        SizedBox(height: 8.h),
        AddressCard(
          imagePath: isStore ? AppIcons.flowerImg : AppIcons.userImg,
          title: isStore ? 'Flowery Store' : (userName ?? 'User'),
          address: address,
        ),
      ],
    );
  }
}
