// features/auth/presentation/apply/widgets/gender_selection.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/string_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';

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
    this.label = '',
  });

  String getLocalizedGender(String value) {
    if (value == 'male') return LocaleKeys.apply_gender_user_male.tr();
    if (value == 'female') return LocaleKeys.apply_gender_user_female.tr();
    return value.capitalize();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.isNotEmpty ? label : LocaleKeys.apply_gender_label.tr(),
          style: getRegularStyle(
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          children: options.map((option) {
            String optionText = getLocalizedGender(option);

            return IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                  Flexible(
                    child: Text(
                      optionText,
                      style: getRegularStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
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
