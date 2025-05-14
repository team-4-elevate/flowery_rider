import 'dart:io';

import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/app_manger/app_cubit.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/get_profile_data_use_case.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/update_car_info_use_case.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/update_user_data_use_case.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._getUserDataUseCase,
    this._appCubit,
    // this._imagePickerService,
    this._updateUserDataUseCase,
    this._updateCarInfoUseCase,
  ) : super(
          const ProfileState(),
        );
  final GetProfileDataUseCase _getUserDataUseCase;
  final UpdateUserDataUseCase _updateUserDataUseCase;
  final UpdateCarInfoUseCase _updateCarInfoUseCase;
  final AppCubit _appCubit;
  // final ImagePickerService _imagePickerService;
  void getUserData() async {
    if (_appCubit.hasProfileData() && _appCubit.isProfileDataFresh()) {
      final userData = _appCubit.cachedUserProfileData;
      emit(state.copyWith(
        getUserDataState: BaseSuccessState<UserDataEntity>(data: userData!),
      ));
      return;
    }
    emit(state.copyWith(getUserDataState: BaseLoadingState()));
    var response = await _getUserDataUseCase.call();
    response.fold(
      (error) {
        emit(state.copyWith(getUserDataState: BaseErrorState(error.message)));
      },
      (userData) {
        _appCubit.saveProfileTabData(userData);
        emit(state.copyWith(
            getUserDataState:
                BaseSuccessState<UserDataEntity>(data: userData)));
      },
    );
  }

  void refreshUserData() async {
    emit(state.copyWith(getUserDataState: BaseLoadingState()));
    var response = await _getUserDataUseCase.call();
    response.fold(
      (error) {
        emit(state.copyWith(getUserDataState: BaseErrorState(error.message)));
      },
      (userData) {
        _appCubit.saveProfileTabData(userData);
        emit(state.copyWith(
            getUserDataState:
                BaseSuccessState<UserDataEntity>(data: userData)));
      },
    );
  }

  void updateUserData({
    String? fName,
    String? lName,
    String? email,
    String? phone,
    // File? userProfileImage,
  }) async {
    emit(state.copyWith(updateUserDataState: BaseLoadingState()));
    var response = await _updateUserDataUseCase.call(
      UpdateUserInfoModel(
        fName: fName,
        lName: lName,
        email: email,
        phone: phone,
        // userProfileImage: userProfileImage,
      ),
      null,
    );
    response.fold(
      (error) {
        emit(
            state.copyWith(updateUserDataState: BaseErrorState(error.message)));
      },
      (userData) {
        emit(state.copyWith(updateUserDataState: BaseSuccessState<void>()));
      },
    );
  }

  void updateCarInfo({
    String? carType,
    String? carNumber,
    File? carLicense,
  }) async {
    emit(state.copyWith(updateCarInfoState: BaseLoadingState()));
    var response = await _updateCarInfoUseCase.call(
      UpdateCarInfoModel(
        vehicleType: carType,
        vehicleNumber: carNumber,
        vehicleLicense: carLicense,
      ),
    );
    response.fold(
      (error) {
        emit(state.copyWith(updateCarInfoState: BaseErrorState(error.message)));
      },
      (userData) {
        emit(state.copyWith(updateCarInfoState: BaseSuccessState<void>()));
      },
    );
  }

// ValueNotifier<File?> selectImage = ValueNotifier(null);
}
