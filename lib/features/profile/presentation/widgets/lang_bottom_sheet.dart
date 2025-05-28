import 'package:flowery_rider/core/app_manger/app_cubit.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LangBottomSheet extends StatefulWidget {
  const LangBottomSheet({super.key});

  @override
  State<LangBottomSheet> createState() => _LangBottomSheetState();
}

class _LangBottomSheetState extends State<LangBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var currentLocale = context.read<AppCubit>().state.appLocale;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(currentLocale == 'ar' ? 'غير اللغة' : 'Change Language',
              style: getBoldStyle(
                fontSize: 20.sp,
                color: AppColors.primary,
              )),
          const SizedBox(height: 16),
          CustomLangRadio(
            title: 'العربية',
            localeValue: const Locale('ar'),
            selectedLocale: Locale(currentLocale),
            onSelected: (value) {
              context.read<AppCubit>().toggleAppLocale(value.toString());
              Navigator.pop(context);
            },
          ),
          CustomLangRadio(
            title: 'English',
            localeValue: const Locale('en'),
            selectedLocale: Locale(currentLocale),
            onSelected: (value) {
              context.read<AppCubit>().toggleAppLocale(value.toString());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class CustomLangRadio extends StatelessWidget {
  final String title;
  final Locale localeValue;
  final Locale selectedLocale;
  final void Function(Locale) onSelected;

  const CustomLangRadio({
    super.key,
    required this.title,
    required this.localeValue,
    required this.selectedLocale,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(localeValue),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          color: AppColors.white[20],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: getMediumStyle(
                fontSize: 16.sp,
                color: AppColors.black,
              ),
            ),
            Radio<Locale>(
              value: localeValue,
              groupValue: selectedLocale,
              onChanged: (value) => onSelected(value!),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
