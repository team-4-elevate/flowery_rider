// features/auth/presentation/widgets/apply_widgets/gender_selection.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';

class GenderSelection extends StatelessWidget {
  final String selectedGender;
  final Function(String) onChanged;
  final List<String> options;
  final String label;

  const GenderSelection({
    super.key,
    required this.selectedGender,
    required this.onChanged,
    this.options = const ['male', 'female'],
    this.label = 'Gender',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getRegularStyle(
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: options.map((option) {
            return Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Row(
                children: [
                  Radio<String>(
                    value: option,
                    groupValue: selectedGender,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(value);
                      }
                    },
                  ),
                  Text(
                    option.capitalize(),
                    style: getRegularStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
