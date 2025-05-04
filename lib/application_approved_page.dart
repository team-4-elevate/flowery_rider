import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/resources/app_icon.dart';
import 'package:flowery_rider/core/resources/app_image.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ApplicationApprovedPage extends StatelessWidget {
  const ApplicationApprovedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppImage.bgApplicationApproved,
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcon.checkCircle,
                  width: 160,
                  height: 160,
                ),
                const SizedBox(height: 24),
                Text(
                  LocaleKeys.applicationApproved_title.tr(),
                  style: getBoldStyle(color: AppColors.black, fontSize: 18.sp),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.applicationApproved_description.tr(),
                  style:
                      getRegularStyle(color: AppColors.grey, fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    LocaleKeys.applicationApproved_login.tr(),
                    style: getMediumStyle(
                      color: AppColors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
