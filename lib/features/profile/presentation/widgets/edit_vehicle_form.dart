import 'dart:io';

import 'package:flowery_rider/core/services/image_picker_service.dart';
import 'package:flowery_rider/core/utils/extensions.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/searchable_dropdown.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/upload_field.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
          hint: 'Select vehicle type',
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
          decoration: const InputDecoration(
            labelText: 'vehicle Number',
          ),
          controller: vehicleNumberController,
        ),
        SizedBox(height: context.heightPercent(2)),
        UploadField(
          hintText: 'Vehicle License',
          file: null,
          label: 'Vehicle License',
          onTap: () {},
        ),
      ],
    );
  }

}
