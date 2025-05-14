import 'dart:io';

import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/services/image_picker_service.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/extensions.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_state.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/edit_user_personal_data_form_fileds.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/edit_vehicle_form.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/user_gender_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditUserProfileDataScreen extends StatelessWidget {
  final bool isEditUserData;
  final UserDataEntity? userdata;

  EditUserProfileDataScreen({
    super.key,
    this.isEditUserData = false,
    required this.userdata,
  });

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.black,
            size: 24,
          ),
        ),
        title: Text(
          'Edit Profile',
          style: getMediumStyle(color: AppColors.black, fontSize: 20),
        ),
        titleSpacing: 0,
        leadingWidth: 35,
        // actions: const [
        //   Icon(
        //     Icons.notifications_none_rounded,
        //     color: AppColors.black,
        //     size: 24,
        //   )
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(
                context.widthPercent(3.5),
              ),
              child: Form(
                // key: profileCubit.editProfileFormKey,
                child: ListView(children: [
                  switch (isEditUserData) {
                    true => _buildEditUserPersonalDataForm(context),
                    false => EditVehicleForm(
                        vehicleNumberController: vehicleNumberController,
                        userdata: userdata!,
                      ),
                  },
                  SizedBox(
                      height: context.heightPercent(isEditUserData ? 8 : 3)),
                  BlocListener<ProfileCubit, ProfileState>(
                    listener: (context, state) {
                      if (state.updateUserDataState is BaseLoadingState) {
                        context.showLoadingIndicator();
                      }
                      if (state.updateUserDataState is BaseErrorState) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.pop();
                          getIt<DialogUtils>().showSnackBar(
                            textColor: AppColors.error,
                            message:
                                (state.updateUserDataState as BaseErrorState)
                                    .errorMessage,
                            context: context,
                          );
                        });
                      }
                      if (state.updateUserDataState is BaseSuccessState) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            context.pop();
                            getIt<DialogUtils>().showSnackBar(
                              textColor: AppColors.success,
                              message: 'User data updated successfully',
                              context: context,
                            );
                          },
                        );
                      }
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        if (isEditUserData) {
                          context.read<ProfileCubit>().updateUserData(
                                fName: firstNameController.text,
                                lName: lastNameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                              );
                        }
                      },
                      child: const Text('Update'),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditUserPersonalDataForm(BuildContext context) {
    return Column(
      children: [
        EditUserPersonalDataFormFields(
          user: userdata!,
          emailController: emailController,
          firstNameController: firstNameController,
          lastNameController: lastNameController,
          phoneController: phoneController,
        ),
        SizedBox(height: context.heightPercent(3)),
        Row(
          children: [
            const Text('Gender'),
            SizedBox(width: context.widthPercent(10)),
            const UserGenderRow(
              value: 'female',
              label: 'Female',
              fillColor: AppColors.primary,
              isSelected: true,
            ),
            SizedBox(width: context.widthPercent(5)),
            const UserGenderRow(
              value: 'male',
              label: 'Male',
              fillColor: AppColors.primary,
              isSelected: false,
            ),
          ],
        ),
      ],
    );
  }
}
