import 'dart:io';
import 'package:flowery_rider/core/app_manger/app_cubit.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_request_model.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/get_profile_data_use_case.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/logout_use_case.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/update_car_info_use_case.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/update_user_data_use_case.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_state.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/result.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._getUserDataUseCase,
    this._appCubit,
    this._updateUserDataUseCase,
    this._updateCarInfoUseCase,
    this._changePasswordUseCase,
    this._logoutUseCase,
  ) : super(
          ProfileState(),
        );
  final GetProfileDataUseCase _getUserDataUseCase;
  final UpdateUserDataUseCase _updateUserDataUseCase;
  final UpdateCarInfoUseCase _updateCarInfoUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final AppCubit _appCubit;
  final LogoutUseCase _logoutUseCase;
  Future<void> getUserData() async {
    if (_appCubit.hasProfileData() && _appCubit.isProfileDataFresh()) {
      final userData = _appCubit.cachedUserProfileData;
      emit(state.copyWith(
        userData: Result.success(userData!),
      ));
      return;
    }
    emit(state.copyWith(userData: Result.loading()));
    var response = await _getUserDataUseCase.call();
    response.fold(
      (error) {
        emit(state.copyWith(userData: Result.error(error.message)));
      },
      (userData) {
        _appCubit.saveProfileTabData(userData);
        emit(state.copyWith(userData: Result.success(userData)));
      },
    );
  }

  Future<void> refreshUserData() async {
    emit(state.copyWith(userData: Result.loading()));
    var response = await _getUserDataUseCase.call();
    response.fold(
      (error) {
        emit(state.copyWith(userData: Result.error(error.message)));
      },
      (userData) {
        _appCubit.saveProfileTabData(userData);
        emit(state.copyWith(userData: Result.success(userData)));
      },
    );
  }

  void updateUserData({
    String? fName,
    String? lName,
    String? email,
    String? phone,
  }) async {
    emit(state.copyWith(updateUserData: Result.loading()));
    var response = await _updateUserDataUseCase.call(
      UpdateUserInfoModel(
        fName: fName,
        lName: lName,
        email: email,
        phone: phone,
      ),
      userProfileImage.value,
    );
    response.fold(
      (error) {
        emit(state.copyWith(updateUserData: Result.error(error.message)));
      },
      (userData) {
        _appCubit.saveProfileTabData(userData);
        // userProfileImage.value = null;
        emit(
          state.copyWith(
            updateUserData: Result.success(userData),
          ),
        );
      },
    );
  }

  void updateCarInfo({
    String? carType,
    String? carNumber,
    File? carLicense,
  }) async {
    emit(state.copyWith(updateCarInfo: Result.loading()));
    var response = await _updateCarInfoUseCase.call(
      UpdateCarInfoModel(
        vehicleType: carType,
        vehicleNumber: carNumber,
        vehicleLicense: carLicense,
      ),
      _appCubit.cachedUserProfileData!.vehicleType,
    );
    response.fold(
      (error) {
        emit(state.copyWith(updateCarInfo: Result.error(error.message)));
      },
      (updated) {
        emit(state.copyWith(
          updateCarInfo: Result.success(updated),
        ));
      },
    );
  }

  void changePassword({
    String? oldPassword,
    String? newPassword,
    // String? confirmPassword,
  }) async {
    emit(state.copyWith(changePassword: Result.loading()));
    var response = await _changePasswordUseCase.call(
      ChangePasswordRequestModel(
        oldPassword: oldPassword ?? '',
        newPassword: newPassword ?? '',
        // confirmPassword: confirmPassword??'',
      ),
    );
    response.fold(
      (error) {
        emit(state.copyWith(changePassword: Result.error(error.message)));
      },
      (changed) {
        emit(
          state.copyWith(
            changePassword: Result.success(changed),
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(logout: Result.loading()));
    var response = await _logoutUseCase.call();
    response.fold(
      (error) {
        emit(state.copyWith(logout: Result.error(error.toString())));
      },
      (success) {
        _appCubit.clearProfileData();
        emit(state.copyWith(logout: Result.success(success)));
      },
    );
  }

  void resetStates() {
    final userData = state.userData;
    final newState = ProfileState(
      userData: userData,
      updateUserData: const Result.initial(),
      updateCarInfo: const Result.initial(),
      changePassword: const Result.initial(),
      logout: const Result.initial(),
    );

    emit(newState);
  }

  ValueNotifier<File?> userProfileImage = ValueNotifier(null);

  @override
  Future<void> close() {
    userProfileImage.dispose();
    return super.close();
  }
}
