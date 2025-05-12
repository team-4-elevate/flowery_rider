// features/auth/presentation/apply/widgets/vehicle_type_dropdown.dart
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/searchable_dropdown.dart';

class VehicleTypeDropdown extends StatelessWidget {
  final String? selectedValue;
  final Function(String?) onChanged;
  final List<VehicleTypeOption> options;
  final String? hintText;

  const VehicleTypeDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.options,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SearchableDropdown<String>(
      hint: hintText ?? LocaleKeys.apply_select_vehicle_type.tr(),
      value: selectedValue,
      items: options.map((option) => option.value).toList(),
      onChanged: onChanged,
      displayStringForOption: (value) {
        final option = options
            .firstWhere(
              (option) => option.value == value,
              orElse: () =>
                  VehicleTypeOption('', LocaleKeys.apply_apply_not_found.tr()),
            );
        return option.label.tr();
      },
      itemBuilder: (value) {
        final option = options.firstWhere(
          (option) => option.value == value,
          orElse: () =>
              VehicleTypeOption('', LocaleKeys.apply_apply_not_found.tr()),
        );

        return Text(
          option.label.tr(),
          style: TextStyle(
            fontSize: 14.sp,
            color: value == selectedValue
                ? Theme.of(context).primaryColor
                : AppColors.black,
            fontWeight:
                value == selectedValue ? FontWeight.bold : FontWeight.normal,
          ),
        );
      },
    );
  }
}

class VehicleTypeOption {
  final String value;
  final String label;

  const VehicleTypeOption(this.value, this.label);
}
