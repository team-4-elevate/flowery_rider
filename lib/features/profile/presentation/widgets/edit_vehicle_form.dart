import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/utils/extensions.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/searchable_dropdown.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/upload_field.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

class EditVehicleForm extends StatelessWidget {
  final TextEditingController vehicleNumberController;
  final UserDataEntity userdata;
  const EditVehicleForm(
      {super.key,
      required this.vehicleNumberController,
      required this.userdata});

  @override
  Widget build(BuildContext context) {
    vehicleNumberController.text = userdata.vehicleNumber;
    return Column(
      children: [
        SearchableDropdown(
          hint: LocaleKeys.profile_vehicle_type_hint.tr(),
          items: const [],
          onChanged: (value) {},
          displayStringForOption: (option) => option.toString(),
          value: userdata.vehicleType,
          itemBuilder: (item) => Container(),
        ),
        SizedBox(height: context.heightPercent(2)),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          validator: (value) => Validator.validateVehicleNumber(value),
          decoration: InputDecoration(
            labelText: LocaleKeys.profile_vehicle_number_hint.tr(),
          ),
          controller: vehicleNumberController,
        ),
        SizedBox(height: context.heightPercent(2)),
        UploadField(
          hintText: LocaleKeys.profile_vehicle_license_hint.tr(),
          file: null,
          label: LocaleKeys.profile_vehicle_license_label.tr(),
          onTap: () {},
        ),
      ],
    );
  }
}
