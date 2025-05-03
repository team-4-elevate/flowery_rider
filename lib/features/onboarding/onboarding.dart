// features/onboarding/onboarding.dart
import 'package:flowery_rider/core/resources/app_image.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 1),

            // logo
            SizedBox(
              width: double.infinity,
              height: 350.h,
              child: OverflowBox(
                maxWidth: 660.w,
                maxHeight: 600.h,
                alignment: Alignment.lerp(
                  Alignment.center,
                  Alignment.centerRight,
                  0.1,
                )!,
                child: Lottie.asset(
                  AppImage.onboardingAnimation,
                  repeat: true,
                  animate: true,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const Spacer(flex: 1),

            // Welcome Text
            Text(
              LocaleKeys.onboardingWelcomeTo.tr(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              LocaleKeys.onboardingFloweryRiderApp.tr(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const Spacer(flex: 1),

            // Login Button
            ElevatedButton(
              onPressed: () {},
              child: Text(LocaleKeys.onboardingLogin.tr()),
            ),

            SizedBox(height: 16.h),

            // Apply Button
            OutlinedButton(
              onPressed: () {},
              child: Text(LocaleKeys.onboardingApplyNow.tr()),
            ),

            const Spacer(flex: 1),

            // Version Text
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Text(
                  LocaleKeys.onboardingVersion.tr(),
                  style:
                      getRegularStyle(color: AppColors.grey, fontSize: 12.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
