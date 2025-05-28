import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/app_manger/app_cubit.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_request_model.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_response.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/get_profile_data_use_case.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/logout_use_case.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/update_car_info_use_case.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/update_user_data_use_case.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProfileDataUseCase extends Mock implements GetProfileDataUseCase {}

class MockUpdateUserDataUseCase extends Mock implements UpdateUserDataUseCase {}

class MockUpdateCarInfoUseCase extends Mock implements UpdateCarInfoUseCase {}

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockAppCubit extends Mock implements AppCubit {}

void main() {
  late ProfileCubit cubit;
  late MockGetProfileDataUseCase getProfileDataUseCase;
  late MockUpdateUserDataUseCase updateUserDataUseCase;
  late MockUpdateCarInfoUseCase updateCarInfoUseCase;
  late MockChangePasswordUseCase changePasswordUseCase;
  late MockLogoutUseCase logoutUseCase;
  late MockAppCubit appCubit;

  setUp(() {
    getProfileDataUseCase = MockGetProfileDataUseCase();
    updateUserDataUseCase = MockUpdateUserDataUseCase();
    updateCarInfoUseCase = MockUpdateCarInfoUseCase();
    changePasswordUseCase = MockChangePasswordUseCase();
    logoutUseCase = MockLogoutUseCase();
    appCubit = MockAppCubit();

    cubit = ProfileCubit(
      getProfileDataUseCase,
      appCubit,
      updateUserDataUseCase,
      updateCarInfoUseCase,
      changePasswordUseCase,
      logoutUseCase,
    );
  });

  setUpAll(() {
    registerFallbackValue(UpdateUserInfoModel(
      fName: '',
      lName: '',
      email: '',
      phone: '',
      userProfileImage: null,
    ));
    registerFallbackValue(UpdateCarInfoModel(
     vehicleLicense: null,
      vehicleNumber: '',
      vehicleType: '',
    ));
    registerFallbackValue(ChangePasswordRequestModel(
      oldPassword: '',
      newPassword: '',
    ));
  });

  final userData = UserDataEntity(
    driverId: 'id',
    userFname: 'fname',
    userLname: 'lname',
    userEmail: 'email',
    userPhone: 'phone',
    userGender: 'gender',
    vehicleType: 'type',
    vehicleNumber: 'number',
    vehicleLicense: 'license',
    userImage: 'img',
  );

  group('getUserData', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, success] when use case returns Right',
      build: () {
        when(() => appCubit.hasProfileData()).thenReturn(false);
        when(() => getProfileDataUseCase.call())
            .thenAnswer((_) async => Right(userData));
        return cubit;
      },
      act: (cubit) => cubit.getUserData(),
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.userData.isLoading, 'loading', true),
        isA<ProfileState>().having((s) => s.userData.data, 'data', userData),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, error] when use case returns Left',
      build: () {
        when(() => appCubit.hasProfileData()).thenReturn(false);
        when(() => getProfileDataUseCase.call())
            .thenAnswer((_) async => Left(ApiException(message: 'fail')));
        return cubit;
      },
      act: (cubit) => cubit.getUserData(),
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.userData.isLoading, 'loading', true),
        isA<ProfileState>().having((s) => s.userData.isError, 'error', true),
      ],
    );
  });

  group('updateUserData', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, success] when updateUserDataUseCase returns Right',
      build: () {
        when(() => updateUserDataUseCase.call(any(), any()))
            .thenAnswer((_) async => Right(userData));
        return cubit;
      },
      act: (cubit) => cubit.updateUserData(
        fName: 'fname',
        lName: 'lname',
        email: 'email',
        phone: 'phone',
      ),
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.updateUserData.isLoading, 'loading', true),
        isA<ProfileState>()
            .having((s) => s.updateUserData.data, 'data', userData),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, error] when updateUserDataUseCase returns Left',
      build: () {
        when(() => updateUserDataUseCase.call(any(), any()))
            .thenAnswer((_) async => Left(ApiException(message: 'fail')));
        return cubit;
      },
      act: (cubit) => cubit.updateUserData(
        fName: 'fname',
        lName: 'lname',
        email: 'email',
        phone: 'phone',
      ),
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.updateUserData.isLoading, 'loading', true),
        isA<ProfileState>()
            .having((s) => s.updateUserData.isError, 'error', true),
      ],
    );
  });

  group('updateCarInfo', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, success] when updateCarInfoUseCase returns Right',
      build: () {
        when(() => appCubit.cachedUserProfileData).thenReturn(userData);
        when(() => updateCarInfoUseCase.call(any(), any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.updateCarInfo(
        carType: 'type',
        carNumber: 'number',
        carLicense: File('license'),
      ),
     expect: () => [
  isA<ProfileState>().having((s) => s.updateCarInfo.isLoading, 'loading', true),
  isA<ProfileState>().having((s) => s.updateCarInfo.isLoading, 'loading', false),
],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, error] when updateCarInfoUseCase returns Left',
      build: () {
        when(() => appCubit.cachedUserProfileData).thenReturn(userData);
        when(() => updateCarInfoUseCase.call(any(), any()))
            .thenAnswer((_) async => Left(ApiException(message: 'fail')));
        return cubit;
      },
      act: (cubit) => cubit.updateCarInfo(
        carType: 'type',
        carNumber: 'number',
        carLicense: File('license'),
      ),
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.updateCarInfo.isLoading, 'loading', true),
        isA<ProfileState>()
            .having((s) => s.updateCarInfo.isError, 'error', true),
      ],
    );
  });

  group('changePassword', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, success] when changePasswordUseCase returns Right',
      build: () {
        when(() => changePasswordUseCase.call(any()))
            .thenAnswer((_) async => Right(ChangePasswordResponse(
                  message: 'Password changed successfully',
                  token: 'new_token',
                )));
        return cubit;
      },
      act: (cubit) => cubit.changePassword(
        oldPassword: 'old',
        newPassword: 'new',
      ),
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.changePassword.isLoading, 'loading', true),
        isA<ProfileState>()
            .having((s) => s.changePassword.isSuccess, 'success', true),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, error] when changePasswordUseCase returns Left',
      build: () {
        when(() => changePasswordUseCase.call(any()))
            .thenAnswer((_) async => Left(ApiException(message: 'fail')));
        return cubit;
      },
      act: (cubit) => cubit.changePassword(
        oldPassword: 'old',
        newPassword: 'new',
      ),
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.changePassword.isLoading, 'loading', true),
        isA<ProfileState>()
            .having((s) => s.changePassword.isError, 'error', true),
      ],
    );
  });

  group('logout', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, success] when logoutUseCase returns Right',
      build: () {
        when(() => logoutUseCase.call())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.logout(),
     expect: () => [
  isA<ProfileState>().having((s) => s.logout.isLoading, 'loading', true),
  isA<ProfileState>().having((s) => s.logout.isLoading, 'loading', false),
],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, error] when logoutUseCase returns Left',
      build: () {
        when(() => logoutUseCase.call())
            .thenAnswer((_) async => Left(ApiException(message: 'fail')));
        return cubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<ProfileState>().having((s) => s.logout.isLoading, 'loading', true),
        isA<ProfileState>().having((s) => s.logout.isError, 'error', true),
      ],
    );
  });
}
