// features/auth/presentation/apply/widgets/vehicle_info_section.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/upload_field.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/vehicle_type_dropdown.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';

class VehicleInfoSection extends StatelessWidget {
  final String? selectedVehicleType;
  final ValueChanged<String?> onVehicleTypeChanged;
  final TextEditingController vehicleNumberController;
  final Map<String, String> vehicleTypeMap;
  final File? licensePhoto;
  final List<File> licensePhotos;
  final VoidCallback onPickLicensePhoto;
  final VoidCallback onRemoveLicensePhoto;
  final Function(File) onRemoveSpecificLicensePhoto;

  const VehicleInfoSection({
    super.key,
    required this.selectedVehicleType,
    required this.onVehicleTypeChanged,
    required this.vehicleNumberController,
    required this.vehicleTypeMap,
    required this.licensePhoto,
    required this.licensePhotos,
    required this.onPickLicensePhoto,
    required this.onRemoveLicensePhoto,
    required this.onRemoveSpecificLicensePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.apply_vehicle_information.tr(),
          style: getMediumStyle(
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 15.h),
        VehicleTypeDropdown(
          selectedValue: selectedVehicleType,
          onChanged: onVehicleTypeChanged,
          options: vehicleTypeMap.entries
              .map((entry) => VehicleTypeOption(entry.key, entry.value))
              .toList(),
          hintText: LocaleKeys.apply_select_vehicle_type.tr(),
        ),
        SizedBox(height: 15.h),
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.apply_vehicle_number_hint.tr(),
            labelText: LocaleKeys.apply_vehicle_number.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: vehicleNumberController,
          validator: Validator.validateVehicleNumber,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 15.h),
        UploadField(
          label: LocaleKeys.apply_vehicle_license.tr(),
          hintText: LocaleKeys.apply_vehicle_license_hint.tr(),
          file: licensePhoto,
          files: licensePhotos,
          onTap: onPickLicensePhoto,
          onRemove: onRemoveLicensePhoto,
          onRemoveFile: onRemoveSpecificLicensePhoto,
        ),
      ],
    );
  }
}
