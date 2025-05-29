import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:flowery_rider/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_request_model.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_response.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/data/models/user_data_model/driver.dart';
import 'package:flowery_rider/features/profile/data/models/user_data_model/user_data_model.dart';
import 'package:flowery_rider/features/profile/data/repositories/profile_repo_impl.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockFile extends Mock implements File {}

void main() {
  late ProfileRepoImpl repository;
  late MockProfileRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockAuthLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    repository = ProfileRepoImpl(mockRemoteDataSource, mockAuthLocalDataSource);

    // Register fallback values
    registerFallbackValue(UpdateCarInfoModel(
      vehicleType: '',
      vehicleNumber: '',
      vehicleLicense: null,
    ));
    registerFallbackValue(UpdateUserInfoModel(
      fName: '',
      lName: '',
      email: '',
      phone: '',
      userProfileImage: null,
    ));
    registerFallbackValue(ChangePasswordRequestModel(
      oldPassword: '',
      newPassword: '',
    ));
  });

  group('getUserProfileData', () {
    final mockDriverData = DriverData(
      id: '680b99681433a666c8d4ea89',
      firstName: 'abdos',
      lastName: 'saeed',
      email: 'abdelrhmansaeedx@gmail.com',
      phone: '+201025433520',
      gender: 'male',
      vehicleType: '676b31a45d05310ca82657ac',
      vehicleNumber: '12221',
      vehicleLicense: 'https://flower.elevateegy.com/uploads/license.png',
      country: 'Egypt',
      nid: '12345678912345',
      photo: 'https://flower.elevateegy.com/uploads/photo.jpg',
      role: 'driver',
      createdAt: DateTime.parse('2025-04-25T14:17:12.104Z'),
    );

    final mockUserDataModel = UserDataModel(
      message: 'success',
      driver: mockDriverData,
    );

    test('should return UserDataEntity when remote data source succeeds',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getUserProfileData())
          .thenAnswer((_) async => mockUserDataModel);

      // Act
      final result = await repository.getUserProfileData();

      // Assert
      expect(result, isA<Right<ApiException, UserDataEntity>>());

      result.fold(
        (error) => fail('Should return success'),
        (userEntity) {
          expect(userEntity.driverId, equals('680b99681433a666c8d4ea89'));
          expect(userEntity.userFname, equals('abdos'));
          expect(userEntity.userLname, equals('saeed'));
          expect(userEntity.userEmail, equals('abdelrhmansaeedx@gmail.com'));
          expect(userEntity.userPhone, equals('+201025433520'));
          expect(userEntity.userGender, equals('male'));
          expect(userEntity.vehicleType, equals('676b31a45d05310ca82657ac'));
          expect(userEntity.vehicleNumber, equals('12221'));
        },
      );

      verify(() => mockRemoteDataSource.getUserProfileData()).called(1);
    });

    test('should return ApiException when remote data source throws exception',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getUserProfileData())
          .thenThrow(Exception('Network error'));

      // Act
      final result = await repository.getUserProfileData();

      // Assert
      expect(result, isA<Left<ApiException, UserDataEntity>>());

      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, contains('Network error'));
        },
        (success) => fail('Should return error'),
      );

      verify(() => mockRemoteDataSource.getUserProfileData()).called(1);
    });
  });

  group('updateDriverCarInfo', () {
    final updateCarInfoModel = UpdateCarInfoModel(
      vehicleType: 'New Car Type',
      vehicleNumber: 'New1234',
      vehicleLicense: null, // Assuming license is optional for this test
    );
    const driverId = '123';

    test('should return success when remote data source succeeds', () async {
      // Arrange
      when(() => mockRemoteDataSource.updateDriverCarInfo(
            any(),
            any(),
          )).thenAnswer((_) async => {});

      // Act
      final result =
          await repository.updateDriverCarInfo(updateCarInfoModel, driverId);

      // Assert
      expect(result, isA<Right<ApiException, void>>());

      result.fold(
        (error) => fail('Should return success'),
        (_) {}, // Success case with void return type, nothing to assert
      );

      verify(() => mockRemoteDataSource.updateDriverCarInfo(
            updateCarInfoModel,
            driverId,
          )).called(1);
    });

    test('should return ApiException when remote data source throws exception',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.updateDriverCarInfo(
            any(),
            any(),
          )).thenThrow(Exception('Update failed'));

      // Act
      final result =
          await repository.updateDriverCarInfo(updateCarInfoModel, driverId);

      // Assert
      expect(result, isA<Left<ApiException, void>>());

      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, contains('Update failed'));
        },
        (success) => fail('Should return error'),
      );
    });
  });

  group('updateUserInfo', () {
    final updateUserInfoModel = UpdateUserInfoModel(
      fName: 'New',
      lName: 'Name',
      email: 'new@example.com',
      phone: '01234567890',
      userProfileImage: null,
    );

    final mockDriverData = DriverData(
      id: '123',
      firstName: 'New',
      lastName: 'Name',
      email: 'new@example.com',
      phone: '01234567890',
    );

    final mockUserDataModel = UserDataModel(
      message: 'success',
      driver: mockDriverData,
    );

    test('should return UserDataEntity when updating without image succeeds',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.updateUserInfo(
            any(),
            null,
          )).thenAnswer((_) async => mockUserDataModel);

      // Act
      final result = await repository.updateUserInfo(updateUserInfoModel, null);

      // Assert
      expect(result, isA<Right<ApiException, UserDataEntity>>());

      result.fold(
        (error) => fail('Should return success'),
        (userEntity) {
          expect(userEntity.driverId, equals('123'));
          expect(userEntity.userFname, equals('New'));
          expect(userEntity.userLname, equals('Name'));
          expect(userEntity.userEmail, equals('new@example.com'));
          expect(userEntity.userPhone, equals('01234567890'));
        },
      );

      verify(() => mockRemoteDataSource.updateUserInfo(
            updateUserInfoModel,
            null,
          )).called(1);
    });

    test('should return UserDataEntity when updating with image succeeds',
        () async {
      // Arrange
      final mockFile = MockFile();
      when(() => mockRemoteDataSource.updateUserInfo(
            any(),
            any(),
          )).thenAnswer((_) async => mockUserDataModel);

      // Act
      final result =
          await repository.updateUserInfo(updateUserInfoModel, mockFile);

      // Assert
      expect(result, isA<Right<ApiException, UserDataEntity>>());

      result.fold(
        (error) => fail('Should return success'),
        (userEntity) {
          expect(userEntity.driverId, equals('123'));
          expect(userEntity.userFname, equals('New'));
          expect(userEntity.userLname, equals('Name'));
        },
      );

      verify(() => mockRemoteDataSource.updateUserInfo(
            updateUserInfoModel,
            mockFile,
          )).called(1);
    });

    test('should return ApiException when remote data source throws exception',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.updateUserInfo(
            any(),
            any(),
          )).thenThrow(Exception('Update failed'));

      // Act
      final result = await repository.updateUserInfo(updateUserInfoModel, null);

      // Assert
      expect(result, isA<Left<ApiException, UserDataEntity>>());

      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, contains('Update failed'));
        },
        (success) => fail('Should return error'),
      );
    });
  });

  group('changePassword', () {
    final changePasswordModel = ChangePasswordRequestModel(
      oldPassword: 'old123',
      newPassword: 'new123',
    );

    final mockChangePasswordResponse = ChangePasswordResponse(
      message: 'Password changed successfully',
      token: 'new_jwt_token_here',
    );

    test('should return ChangePasswordResponse and cache token when succeeds',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.changePassword(any()))
          .thenAnswer((_) async => mockChangePasswordResponse);
      when(() => mockAuthLocalDataSource.cacheToken(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.changePassword(changePasswordModel);

      // Assert
      expect(result, isA<Right<ApiException, ChangePasswordResponse>>());

      result.fold(
        (error) => fail('Should return success'),
        (response) {
          expect(response.message, equals('Password changed successfully'));
          expect(response.token, equals('new_jwt_token_here'));
        },
      );

      verify(() => mockRemoteDataSource.changePassword(changePasswordModel))
          .called(1);
      verify(() => mockAuthLocalDataSource.cacheToken('new_jwt_token_here'))
          .called(1);
    });

    test('should cache empty string when token is null', () async {
      // Arrange
      final responseWithoutToken = ChangePasswordResponse(
        message: 'Password changed successfully',
        token: null,
      );

      when(() => mockRemoteDataSource.changePassword(any()))
          .thenAnswer((_) async => responseWithoutToken);
      when(() => mockAuthLocalDataSource.cacheToken(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.changePassword(changePasswordModel);

      // Assert
      expect(result, isA<Right<ApiException, ChangePasswordResponse>>());

      verify(() => mockAuthLocalDataSource.cacheToken('')).called(1);
    });

    test('should return ApiException when remote data source throws exception',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.changePassword(any()))
          .thenThrow(Exception('Password change failed'));

      // Act
      final result = await repository.changePassword(changePasswordModel);

      // Assert
      expect(result, isA<Left<ApiException, ChangePasswordResponse>>());

      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, contains('Password change failed'));
        },
        (success) => fail('Should return error'),
      );

      verify(() => mockRemoteDataSource.changePassword(changePasswordModel))
          .called(1);
      verifyNever(() => mockAuthLocalDataSource.cacheToken(any()));
    });

    test('should return ApiException when token caching fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.changePassword(any()))
          .thenAnswer((_) async => mockChangePasswordResponse);
      when(() => mockAuthLocalDataSource.cacheToken(any()))
          .thenThrow(Exception('Cache failed'));

      // Act
      final result = await repository.changePassword(changePasswordModel);

      // Assert
      expect(result, isA<Left<ApiException, ChangePasswordResponse>>());

      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, contains('Cache failed'));
        },
        (success) => fail('Should return error'),
      );

      verify(() => mockRemoteDataSource.changePassword(changePasswordModel))
          .called(1);
      verify(() => mockAuthLocalDataSource.cacheToken('new_jwt_token_here'))
          .called(1);
    });
  });
}
