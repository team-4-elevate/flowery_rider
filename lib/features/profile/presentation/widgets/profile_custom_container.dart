import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/extensions.dart';
import 'package:flowery_rider/core/widget/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCustomContainer extends StatelessWidget {
  final bool? isEditUserData;
  final String? imageUrl;
  final String? textNameOrInfo;
  final String? emailOrType;
  final String? phoneOrVehicleNum;
  final void Function()? onTap;
  const ProfileCustomContainer({
    super.key,
    this.isEditUserData,
    this.imageUrl,
    required this.textNameOrInfo,
    required this.emailOrType,
    required this.phoneOrVehicleNum,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      highlightColor: AppColors.grey.withOpacity(.03),
      splashColor: AppColors.grey.withOpacity(.03),
      onTap: onTap,
      child: Container(
        height: context.heightPercent(14.5),
        width: context.widthPercent(100.1),
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPercent(1),
          vertical: context.heightPercent(1.5),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: context.widthPercent(1.9),
          vertical: context.heightPercent(1.5),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(.25),
              blurRadius: 4,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Row(
          children: [
            if (isEditUserData == true)
              AppNetworkImage(
                networkImage: imageUrl ?? '',
                width: 60.r,
                height: 60.r,
                borderRadius: BorderRadius.circular(100),
                fit: BoxFit.cover,
              ),
            SizedBox(width: context.widthPercent(5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      textNameOrInfo ?? '',
                      style: getBoldStyle(color: AppColors.black, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: context.heightPercent(0.5)),
                  Expanded(
                    child: Text(
                      emailOrType ?? '',
                      style: getRegularStyle(
                        color: AppColors.black,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: context.heightPercent(0.5)),
                  Expanded(
                    child: Text(
                      phoneOrVehicleNum ?? '',
                      style: getRegularStyle(
                        color: AppColors.black,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
