import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/extensions.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_state.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/edit_user_personal_data_form_fileds.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/edit_vehicle_form.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/success_dilog.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/user_gender_row.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  final bool isEditUserData;
  final UserDataEntity? userdata;
  final bool? isUpdated;

  EditProfileScreen({
    super.key,
    this.isEditUserData = false,
    required this.userdata,
    this.isUpdated,
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
  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();

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
          LocaleKeys.profile_edit_profile_title.tr(),
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
              child: ListView(children: [
                switch (isEditUserData) {
                  true => _buildEditUserPersonalDataForm(context),
                  false => EditVehicleForm(
                      vehicleNumberController: vehicleNumberController,
                      userdata: userdata!,
                    ),
                },
                SizedBox(height: context.heightPercent(isEditUserData ? 8 : 3)),
                BlocListener<ProfileCubit, ProfileState>(
                  listenWhen: (previous, current) =>
                      previous.updateUserData != current.updateUserData ||
                      previous.updateCarInfo != current.updateCarInfo,
                  listener: (context, state) {
                    if (isEditUserData) {
                      state.updateUserData.when(
                        initial: () => {
                          // do nothing
                        },
                        loading: () {
                          context.showLoadingIndicator();
                        },
                        success: (userData) {
                          context.hideLoadingIndicator();
                          context.read<ProfileCubit>().resetStates();
                          SuccessAnimationDialog.show(
                            context: context,
                            message: LocaleKeys
                                .profile_edit_profile_success_profile_updated
                                .tr(),
                            onDismissed: () async {
                              var profileCubit = context.read<ProfileCubit>();
                              if (context.mounted) {
                                await profileCubit.getUserData();
                                profileCubit.userProfileImage.value = null;
                                context.pop();
                              }
                            },
                          );
                        },
                        error: (errorMessage) {
                          context.hideLoadingIndicator();
                          getIt<DialogUtils>().showSnackBar(
                            textColor: AppColors.error,
                            message: errorMessage,
                            context: context,
                          );
                        },
                      );
                    } else {
                      state.updateCarInfo.when(
                        initial: () {},
                        loading: () {
                          context.showLoadingIndicator();
                        },
                        success: (_) async {
                          context.hideLoadingIndicator();
                          context.read<ProfileCubit>().resetStates();
                          if (context.mounted) {
                            SuccessAnimationDialog.show(
                              context: context,
                              message: LocaleKeys
                                  .profile_edit_profile_success_vehicle_updated
                                  .tr(),
                              onDismissed: () async {
                                if (context.mounted) {
                                  await context
                                      .read<ProfileCubit>()
                                      .getUserData();
                                  context.pop();
                                }
                              },
                            );
                          }
                        },
                        error: (errorMessage) {
                          context.pop();
                          getIt<DialogUtils>().showSnackBar(
                            textColor: AppColors.error,
                            message: errorMessage,
                            context: context,
                          );
                        },
                      );
                    }
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      if (isEditUserData) {
                        validateForm(context);
                      } else {
                        context.read<ProfileCubit>().updateCarInfo(
                              carLicense: null,
                              carNumber: vehicleNumberController.text,
                              carType: 'car',
                            );
                      }
                    },
                    child: Text(
                      LocaleKeys.profile_edit_profile_update_button.tr(),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditUserPersonalDataForm(BuildContext context) {
    var profileCubit = context.read<ProfileCubit>();
    return Form(
      key: editProfileFormKey,
      child: Column(
        children: [
          EditUserPersonalDataFormFields(
            user: userdata!,
            profileCubit: profileCubit,
            emailController: emailController,
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            phoneController: phoneController,
          ),
          SizedBox(height: context.heightPercent(3)),
          Row(
            children: [
              Text(LocaleKeys.profile_edit_profile_gender_label.tr()),
              SizedBox(width: context.widthPercent(10)),
              UserGenderRow(
                value: 'female',
                label: LocaleKeys.profile_edit_profile_gender_female.tr(),
                fillColor: AppColors.primary,
                isSelected: (context
                            .read<ProfileCubit>()
                            .state
                            .userData
                            .data
                            ?.userGender ??
                        '') ==
                    'female',
              ),
              SizedBox(width: context.widthPercent(5)),
              UserGenderRow(
                value: 'male',
                label: LocaleKeys.profile_edit_profile_gender_male.tr(),
                fillColor: AppColors.primary,
                isSelected: (context
                            .read<ProfileCubit>()
                            .state
                            .userData
                            .data
                            ?.userGender ??
                        '') ==
                    'male',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void validateForm(BuildContext context) {
    if (editProfileFormKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateUserData(
            fName: firstNameController.text,
            lName: lastNameController.text,
            email: emailController.text,
            phone: '+2${phoneController.text}',
          );
    }
  }
}
