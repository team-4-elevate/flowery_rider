import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/app_manger/app_cubit.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/extensions.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/main_layout/cubit/layout_cubit.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_state.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/lang_bottom_sheet.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/logout_dilog.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/profile_custom_container.dart';
import 'package:flowery_rider/features/profile/presentation/widgets/profile_custom_row.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
            title: Text(
              LocaleKeys.profile_title.tr(),
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
                return state.userData.maybeWhen(
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  },
                  success: (userData) {
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
                            onTap: () async {
                              await Navigator.pushNamed(
                                context,
                                Routes.editProfile,
                                arguments: {
                                  'userData': userData,
                                  'isEditUserData': true,
                                  'profileCubit': context.read<ProfileCubit>(),
                                },
                              );
                            },
                          ),

                          // Vehicle info
                          ProfileCustomContainer(
                            isEditUserData: false,
                            textNameOrInfo:
                                LocaleKeys.profile_vehicle_info.tr(),
                            emailOrType: userData.vehicleType,
                            phoneOrVehicleNum: userData.vehicleNumber,
                            onTap: () async {
                              await Navigator.pushNamed(
                                context,
                                Routes.editProfile,
                                arguments: {
                                  'userData': userData,
                                  'isEditUserData': false,
                                  'profileCubit': context.read<ProfileCubit>(),
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: context.heightPercent(2.4),
                          ),

                          // Language Row
                          ProfileCustomRow(
                            title: LocaleKeys.profile_language.tr(),
                            leftWidget: const Icon(
                              Icons.translate_outlined,
                              color: AppColors.black,
                              size: 16,
                            ),
                            rightWidget: Text(
                                context.read<AppCubit>().state.appLocale == 'ar'
                                    ? 'العربية'
                                    : 'English',
                                style: getRegularStyle(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                )),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.all(
                                      context.widthPercent(3.5),
                                    ),
                                    child: LangBottomSheet(),
                                  );
                                },
                              ).then(
                                (value) {
                                  // if (context.mounted) {
                                  //   context.read<LayoutCubit>().changeIndex(0);
                                  // }
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: context.heightPercent(.8),
                          ),
                          // logout Row
                          ProfileCustomRow(
                            title: LocaleKeys.profile_logout.tr(),
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
                              showDialog(
                                context: context,
                                builder: (builderContext) {
                                  return LogoutDialog(
                                    cubit: context.read<ProfileCubit>(),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: context.heightPercent(20)),
                          Text(
                            LocaleKeys.profile_version_text.tr(),
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
                  error: (errorMessage) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      getIt<DialogUtils>().showSnackBar(
                        textColor: AppColors.error,
                        message: errorMessage,
                        context: context,
                      );
                    });

                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            LocaleKeys.profile_error_load_failure.tr(),
                            style: getRegularStyle(
                              fontSize: 16,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<ProfileCubit>().refreshUserData(),
                            child: Text(LocaleKeys.profile_error_retry.tr()),
                          ),
                        ],
                      ),
                    );
                  },
                  orElse: () {
                    return Center(
                      child: Text(LocaleKeys.profile_no_data.tr()),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
