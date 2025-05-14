import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/extensions.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_state.dart';
import 'package:flowery_rider/features/profile/presentation/pages/edit_user_profile_data_screen.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/profile_custom_container.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/profile_custom_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..getUserData(),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {},
            ),
            title: const Text(
              'Profile',
            ),
            leadingWidth: 30,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.widthPercent(1.6),
              vertical: context.heightPercent(1.6),
            ),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state.getUserDataState is BaseLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }
                if (state.getUserDataState is BaseErrorState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    getIt<DialogUtils>().showSnackBar(
                      textColor: AppColors.error,
                      message: (state.getUserDataState as BaseErrorState)
                          .errorMessage,
                      context: context,
                    );
                  });
                }

                if (state.getUserDataState is! BaseSuccessState) {
                  return const Center(child: Text('No data available'));
                }

                UserDataEntity userData =
                    (state.getUserDataState as BaseSuccessState).data;

                return RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: Colors.white,
                  onRefresh: () {
                    context.read<ProfileCubit>().refreshUserData();
                    return Future<void>.value();
                  },
                  child: ListView(
                    children: [
                      // User info
                      ProfileCustomContainer(
                        isEditUserData: true,
                        imageUrl: userData.userImage,
                        textNameOrInfo:
                            '${userData.userFname} ${userData.userLname}',
                        emailOrType: userData.userEmail,
                        phoneOrVehicleNum: userData.userPhone,
                        onTap: () {
                          final profileCubit = context.read<ProfileCubit>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: profileCubit,
                                child: EditUserProfileDataScreen(
                                  isEditUserData: true,
                                  userdata: userData,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Vehicle info
                      ProfileCustomContainer(
                        isEditUserData: false,
                        textNameOrInfo: 'Vehicle info',
                        emailOrType: userData.vehicleType,
                        phoneOrVehicleNum: userData.vehicleNumber,
                        onTap: () {
                          final profileCubit = context.read<ProfileCubit>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: profileCubit,
                                child: EditUserProfileDataScreen(
                                  isEditUserData: false,
                                  userdata: userData,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: context.heightPercent(2.4),
                      ),

                      // Language Row
                      ProfileCustomRow(
                        title: 'Language',
                        leftWidget: const Icon(
                          Icons.translate_outlined,
                          color: AppColors.black,
                          size: 16,
                        ),
                        rightWidget: Text('English',
                            style: getRegularStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                            )),
                        onTap: () {
                          // Handle language selection action
                        },
                      ),
                      SizedBox(
                        height: context.heightPercent(.8),
                      ),
                      // logout Row
                      ProfileCustomRow(
                        title: 'logout',
                        leftWidget: const Icon(
                          Icons.logout,
                          color: AppColors.grey,
                        ),
                        rightWidget: const Icon(
                          Icons.logout_outlined,
                          color: AppColors.grey,
                          size: 24,
                        ),
                        onTap: () {
                          // Handle logout action
                        },
                      ),
                      SizedBox(height: context.heightPercent(20)),
                      Text(
                        'v 6.3.0 - (446)',
                        style: getRegularStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: context.heightPercent(2.4),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
