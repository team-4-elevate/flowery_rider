// core/theme/theme_data/theme_data_light.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_colors.dart';
import '../app_fonts.dart';
import '../app_styles.dart';

ThemeData getLightTheme() => ThemeData(
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      brightness: Brightness.light,
      fontFamily: AppFonts.interFont,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.scaffoldBackground,
        foregroundColor: AppColors.black,
        titleTextStyle: getMediumStyle(
          color: AppColors.black,
          fontSize: 20.sp,
        ),
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.scaffoldBackground,
          disabledBackgroundColor: AppColors.disableButton,
          disabledForegroundColor: AppColors.scaffoldBackground,
          // elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          minimumSize: Size(double.infinity, 48.h),
        ),
      ),
      //outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white[90]!,
          backgroundColor: AppColors.scaffoldBackground,
          side: const BorderSide(
            color: AppColors.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          minimumSize: Size(double.infinity, 48.h),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        // contentPadding: EdgeInsets.zero,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle:
            getRegularStyle(color: AppColors.white[70]!, fontSize: 14.sp),
        errorStyle: getRegularStyle(color: AppColors.error, fontSize: 14.sp),
        labelStyle: getRegularStyle(color: AppColors.grey, fontSize: 14.sp),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: Color(0xff1D1B20),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: Color(0xff1D1B20),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.white[80]!,
        showUnselectedLabels: true,
        selectedLabelStyle:
            getRegularStyle(color: AppColors.primary, fontSize: 12.sp),
        unselectedLabelStyle:
            getRegularStyle(color: AppColors.white[80]!, fontSize: 12.sp),
      ),
    );
