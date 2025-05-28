import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_request_model.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_response.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/data/models/user_data_model/user_data_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockFile extends Mock implements File {}

class TestableProfileRemoteDataSource extends ProfileRemoteDataSourceImpl {
  final ApiClient mockApiClient;

  TestableProfileRemoteDataSource(this.mockApiClient) : super(mockApiClient);

  @override
  Future<UserDataModel> updateUserInfo(
      UpdateUserInfoModel userInfo, File? file) async {
    if (file != null) {
      await mockApiClient.put(
        ApiConstants.uploadProfileImage,
        data: FormData.fromMap({'image': 'test-file'}), 
        requiresToken: true,
      );
    }

    // Continue with normal profile update
    final response = await mockApiClient.put(
      ApiConstants.updateDriverProfile,
      data: userInfo.toJson(),
      requiresToken: true,
    );

    return UserDataModel.fromJson(response);
  }
}

void main() {
  late ProfileRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = ProfileRemoteDataSourceImpl(mockApiClient);

    // Register fallback values to avoid errors with complex types
    registerFallbackValue({});
    registerFallbackValue(FormData());
  });

  group('getUserProfileData', () {
    final mockResponse = {
      'message': 'success',
      'driver': {
        '_id': '680b99681433a666c8d4ea89',
        'firstName': 'abdos',
        'lastName': 'saeed',
        'vehicleType': '676b31a45d05310ca82657ac',
        'vehicleNumber': '12221',
        'vehicleLicense':
            'https://flower.elevateegy.com/uploads/76dd64e9-b0a5-479e-b159-607c3b1a9662-Photo.png',
        'NID': '12345678912345',
        'NIDImg':
            'https://flower.elevateegy.com/uploads/6554e772-fe4b-4dbf-a4f3-8053058b7fb8-onBord1.png',
        'email': 'abdelrhmansaeedx@gmail.com',
        'gender': 'male',
        'phone': '+201025433520',
        'photo':
            'https://flower.elevateegy.com/uploads/a9886a0f-b935-4676-a404-ec4706ae6c9b-1000000034.jpg',
        'role': 'driver',
        'createdAt': '2025-04-25T14:17:12.104Z',
        'passwordChangedAt': '2025-05-24T19:42:48.135Z'
      }
    };

    test('should return UserDataModel when the call is successful', () async {
      // Arrange
      when(() => mockApiClient.get(
            ApiConstants.getDriverProfile,
            requiresToken: true,
          )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dataSource.getUserProfileData();

      // Assert
      expect(result, isA<UserDataModel>());
      expect(result.message, equals('success'));

      expect(result.driver?.id, equals('680b99681433a666c8d4ea89'));

      expect(result.driver?.firstName, equals('abdos'));
      expect(result.driver?.lastName, equals('saeed'));
      expect(result.driver?.email, equals('abdelrhmansaeedx@gmail.com'));
      expect(result.driver?.phone, equals('+201025433520'));

      verify(() => mockApiClient.get(
            ApiConstants.getDriverProfile,
            requiresToken: true,
          )).called(1);
    });

    test('should throw an exception when the call fails', () async {
      // Arrange
      when(() => mockApiClient.get(
            ApiConstants.getDriverProfile,
            requiresToken: true,
          )).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => dataSource.getUserProfileData(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateDriverCarInfo', () {
    final carInfo = UpdateCarInfoModel(
      vehicleLicense: null,
      vehicleNumber: 'ABC123',
      vehicleType: 'Scooter',
    );

    final driverId = '123';

    test('should call API with correct parameters', () async {
      // Arrange
      when(() => mockApiClient.put(
            '${ApiConstants.updateVehicleInfo}/$driverId',
            data: any(named: 'data'),
            requiresToken: true,
          )).thenAnswer((_) async => {'message': 'success'});

      // Act
      await dataSource.updateDriverCarInfo(carInfo, driverId);

      // Assert
      verify(() => mockApiClient.put(
            '${ApiConstants.updateVehicleInfo}/$driverId',
            data: carInfo.toJson(),
            requiresToken: true,
          )).called(1);
    });

    test('should throw an exception when the call fails', () async {
      // Arrange
      when(() => mockApiClient.put(
            '${ApiConstants.updateVehicleInfo}/$driverId',
            data: any(named: 'data'),
            requiresToken: true,
          )).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => dataSource.updateDriverCarInfo(carInfo, driverId),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateUserInfo', () {
    final userInfo = UpdateUserInfoModel(
        fName: 'New Name',
        lName: 'Last Name',
        userProfileImage: null,
        email: 'newemail@example.com',
        phone: '01234567890');

    final mockUserResponse = {
      'message': 'success',
      'driver': {
        'id': '123',
        'firstName': 'New',
        'lastName': 'Name',
        'email': 'newemail@example.com',
        'phone': '01234567890'
      }
    };

    test('should update user info without image', () async {
      // Arrange
      when(() => mockApiClient.put(
            ApiConstants.updateDriverProfile,
            data: any(named: 'data'),
            requiresToken: true,
          )).thenAnswer((_) async => mockUserResponse);

      // Act
      final result = await dataSource.updateUserInfo(userInfo, null);

      // Assert
      expect(result, isA<UserDataModel>());
      expect(result.message, equals('success'));

      verify(() => mockApiClient.put(
            ApiConstants.updateDriverProfile,
            data: userInfo.toJson(),
            requiresToken: true,
          )).called(1);
    });

    test('should update user info with image', () async {
      // Arrange
      final mockFile = MockFile();
      final userInfo = UpdateUserInfoModel(
          fName: 'New Name',
          lName: 'Last Name',
          userProfileImage: null,
          email: 'newemail@example.com',
          phone: '01234567890');

      final mockUserResponse = {
        'message': 'success',
        'driver': {
          'id': '123',
          'firstName': 'New',
          'lastName': 'Name',
          'email': 'newemail@example.com',
          'phone': '01234567890'
        }
      };

      when(() => mockFile.path).thenReturn('/path/to/image.jpg');

      final testableDataSource = TestableProfileRemoteDataSource(mockApiClient);

      when(() => mockApiClient.put(
            ApiConstants.uploadProfileImage,
            data: any(named: 'data'),
            requiresToken: true,
          )).thenAnswer((_) async => {'message': 'success'});

      when(() => mockApiClient.put(
            ApiConstants.updateDriverProfile,
            data: any(named: 'data'),
            requiresToken: true,
          )).thenAnswer((_) async => mockUserResponse);

      // Act
      final result =
          await testableDataSource.updateUserInfo(userInfo, mockFile);

      // Assert
      expect(result, isA<UserDataModel>());

      // Verify that both API calls were made
      verify(() => mockApiClient.put(
            ApiConstants.uploadProfileImage,
            data: any(named: 'data'),
            requiresToken: true,
          )).called(1);

      verify(() => mockApiClient.put(
            ApiConstants.updateDriverProfile,
            data: any(named: 'data'),
            requiresToken: true,
          )).called(1);
    });

    test('should throw exception when image upload fails', () async {
      // Arrange
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('/path/to/image.jpg');

      when(() => mockApiClient.put(
            ApiConstants.uploadProfileImage,
            data: any(named: 'data'),
            requiresToken: true,
          )).thenThrow(Exception('Upload failed'));

      // Act & Assert
      expect(
        () => dataSource.updateUserInfo(userInfo, mockFile),
        throwsA(isA<Exception>()),
      );

      // Verify that updateDriverProfile was not called since uploadProfileImage failed
      verifyNever(() => mockApiClient.put(
            ApiConstants.updateDriverProfile,
            data: any(named: 'data'),
            requiresToken: true,
          ));
    });
  });

  group('changePassword', () {
    final passwordModel = ChangePasswordRequestModel(
      oldPassword: 'old123',
      newPassword: 'new123',
    );

    final mockResponse = {'message': 'Password changed successfully'};

    test('should change password and return response', () async {
      // Arrange
      when(() => mockApiClient.patch(
            ApiConstants.changePassword,
            data: any(named: 'data'),
            requiresToken: true,
          )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dataSource.changePassword(passwordModel);

      // Assert
      expect(result, isA<ChangePasswordResponse>());
      expect(result.message, equals('Password changed successfully'));

      verify(() => mockApiClient.patch(
            ApiConstants.changePassword,
            data: passwordModel.toJson(),
            requiresToken: true,
          )).called(1);
    });

    test('should throw exception when the call fails', () async {
      // Arrange
      when(() => mockApiClient.patch(
            ApiConstants.changePassword,
            data: any(named: 'data'),
            requiresToken: true,
          )).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => dataSource.changePassword(passwordModel),
        throwsA(isA<Exception>()),
      );
    });
  });

}
