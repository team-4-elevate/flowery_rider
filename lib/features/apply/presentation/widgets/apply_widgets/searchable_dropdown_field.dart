// features/apply/presentation/widgets/apply_widgets/searchable_dropdown_field.dart
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/features/apply/presentation/widgets/apply_widgets/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';

class SearchableDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) displayStringForOption;
  final Function(T) onChanged;
  final Widget Function(T)? itemBuilder;
  final Widget Function(T)? selectedItemBuilder;

  const SearchableDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.displayStringForOption,
    required this.onChanged,
    this.itemBuilder,
    this.selectedItemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty || value == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: getRegularStyle(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 5.h),
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Text(
                hint,
                style: getRegularStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getRegularStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 5.h),
        SearchableDropdown<T>(
          hint: hint,
          value: value!,
          items: items,
          displayStringForOption: displayStringForOption,
          onChanged: onChanged,
          itemBuilder:
              itemBuilder ?? (item) => Text(displayStringForOption(item)),
          selectedItemBuilder: selectedItemBuilder,
        ),
      ],
    );
  }
}
