import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 350.h,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Lottie.asset(
                  'assets/ainmations/on-boarding.json',
                ),
              ),
            ),
            Text(
              LocaleKeys.Onboarding_onboarding_title.tr(),
              style: getBoldStyle(
                color: AppColors.black,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.login);
              },
              child: Text(
                LocaleKeys.Onboarding_login.tr(),
                style: getRegularStyle(
                  color: AppColors.white,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(AppColors.scaffoldBackground),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100.r)),
                    side: BorderSide(
                      color: AppColors.black,
                      width: 1.w,
                    ),
                  ),
                ),
              ),
              onPressed: () {},
              child: Text(
                LocaleKeys.Onboarding_apply_now.tr(),
                style: getRegularStyle(color: AppColors.black, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
