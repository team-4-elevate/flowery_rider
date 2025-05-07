// features/auth/presentation/widgets/apply_widgets/vehicle_type_dropdown.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';

class VehicleTypeDropdown extends StatelessWidget {
  final String? selectedValue;
  final Function(String?) onChanged;

  const VehicleTypeDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: selectedValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            isExpanded: true,
            hint: Text(LocaleKeys.auth_apply_select_vehicle_type.tr()),
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            items: [
              DropdownMenuItem<String>(
                value: 'Car',
                child: Text(LocaleKeys.auth_apply_car.tr()),
              ),
              DropdownMenuItem<String>(
                value: 'Motorcycle',
                child: Text(LocaleKeys.auth_apply_motorcycle.tr()),
              ),
              DropdownMenuItem<String>(
                value: 'Bicycle',
                child: Text(LocaleKeys.auth_apply_bicycle.tr()),
              ),
              DropdownMenuItem<String>(
                value: 'Van',
                child: Text(LocaleKeys.auth_apply_van.tr()),
              ),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
