import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/domain/repositories/profile_repo.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/get_profile_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class
class MockProfileRepo extends Mock implements ProfileRepo {}

void main() {
  late GetProfileDataUseCase useCase;
  late MockProfileRepo mockProfileRepo;

  setUp(() {
    mockProfileRepo = MockProfileRepo();
    useCase = GetProfileDataUseCase(mockProfileRepo);
  });

  group('GetProfileDataUseCase', () {
    final mockUserDataEntity = UserDataEntity(
      driverId: '680b99681433a666c8d4ea89',
      userFname: 'John',
      userLname: 'Doe',
      userEmail: 'john.doe@example.com',
      userPhone: '+201234567890',
      userGender: 'male',
      vehicleType: 'car',
      vehicleNumber: 'ABC123',
      vehicleLicense: 'https://example.com/license.jpg',
      // userNationalId: '12345678901234',
      // userNationalIdImage: 'https://example.com/id_image.jpg',
      userImage: 'https://example.com/profile.jpg',
      // userCountry: 'Egypt',
    );

    test('should return UserDataEntity when repository call succeeds',
        () async {
      // Arrange
      when(() => mockProfileRepo.getUserProfileData())
          .thenAnswer((_) async => Right(mockUserDataEntity));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Right<ApiException, UserDataEntity>>());

      result.fold(
        (error) => fail('Should return success'),
        (userEntity) {
          expect(userEntity.driverId, equals('680b99681433a666c8d4ea89'));
          expect(userEntity.userFname, equals('John'));
          expect(userEntity.userLname, equals('Doe'));
          expect(userEntity.userEmail, equals('john.doe@example.com'));
          expect(userEntity.userPhone, equals('+201234567890'));
          expect(userEntity.userGender, equals('male'));
          expect(userEntity.vehicleType, equals('car'));
          expect(userEntity.vehicleNumber, equals('ABC123'));
          // expect(userEntity.userCountry, equals('Egypt'));
        },
      );

      // Verify that the repository method was called exactly once
      verify(() => mockProfileRepo.getUserProfileData()).called(1);
    });

    test('should return ApiException when repository call fails', () async {
      // Arrange
      final apiException = ApiException(
        message: 'Failed to fetch profile data',
        statusCode: 500,
      );

      when(() => mockProfileRepo.getUserProfileData())
          .thenAnswer((_) async => Left(apiException));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Left<ApiException, UserDataEntity>>());

      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, equals('Failed to fetch profile data'));
          expect(error.statusCode, equals(500));
        },
        (success) => fail('Should return error'),
      );

      // Verify that the repository method was called exactly once
      verify(() => mockProfileRepo.getUserProfileData()).called(1);
    });

    test(
        'should return network error when repository returns network exception',
        () async {
      // Arrange
      final networkException = ApiException(
        message: 'Network connection failed',
        statusCode: 0,
      );

      when(() => mockProfileRepo.getUserProfileData())
          .thenAnswer((_) async => Left(networkException));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Left<ApiException, UserDataEntity>>());

      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, equals('Network connection failed'));
          expect(error.statusCode, equals(0));
        },
        (success) => fail('Should return error'),
      );

      verify(() => mockProfileRepo.getUserProfileData()).called(1);
    });

    test('should return unauthorized error when repository returns 401',
        () async {
      // Arrange
      final unauthorizedException = ApiException(
        message: 'Unauthorized access',
        statusCode: 401,
      );

      when(() => mockProfileRepo.getUserProfileData())
          .thenAnswer((_) async => Left(unauthorizedException));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Left<ApiException, UserDataEntity>>());

      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, equals('Unauthorized access'));
          expect(error.statusCode, equals(401));
        },
        (success) => fail('Should return error'),
      );

      verify(() => mockProfileRepo.getUserProfileData()).called(1);
    });

    test('should return not found error when repository returns 404', () async {
      // Arrange
      final notFoundException = ApiException(
        message: 'User profile not found',
        statusCode: 404,
      );

      when(() => mockProfileRepo.getUserProfileData())
          .thenAnswer((_) async => Left(notFoundException));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Left<ApiException, UserDataEntity>>());

      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, equals('User profile not found'));
          expect(error.statusCode, equals(404));
        },
        (success) => fail('Should return error'),
      );

      verify(() => mockProfileRepo.getUserProfileData()).called(1);
    });

    test('should handle multiple consecutive calls correctly', () async {
      // Arrange
      when(() => mockProfileRepo.getUserProfileData())
          .thenAnswer((_) async => Right(mockUserDataEntity));

      // Act
      final result1 = await useCase.call();
      final result2 = await useCase.call();
      final result3 = await useCase.call();

      // Assert
      expect(result1, isA<Right<ApiException, UserDataEntity>>());
      expect(result2, isA<Right<ApiException, UserDataEntity>>());
      expect(result3, isA<Right<ApiException, UserDataEntity>>());

      // Verify that the repository was called three times
      verify(() => mockProfileRepo.getUserProfileData()).called(3);
    });

    test('should handle alternating success and failure calls', () async {
      // Arrange
      final apiException = ApiException(message: 'Temporary error');

      int callCount = 0;
      when(() => mockProfileRepo.getUserProfileData()).thenAnswer((_) async {
        callCount++;
        if (callCount == 1 || callCount == 3) {
          return Right(mockUserDataEntity);
        } else {
          return Left(apiException);
        }
      });

      // Act
      final result1 = await useCase.call();
      final result2 = await useCase.call();
      final result3 = await useCase.call();

      // Assert
      expect(result1, isA<Right<ApiException, UserDataEntity>>());
      expect(result2, isA<Left<ApiException, UserDataEntity>>());
      expect(result3, isA<Right<ApiException, UserDataEntity>>());

      // Verify that the repository was called three times
      verify(() => mockProfileRepo.getUserProfileData()).called(3);
    });

    test('should pass through exact same result from repository', () async {
      // Arrange
      final specificUserEntity = UserDataEntity(
        driverId: 'specific-id-123',
        userFname: 'Jane',
        userLname: 'Smith',
        userEmail: 'jane.smith@test.com',
        userPhone: '+201987654321',
        userGender: 'female',
        vehicleType: 'motorcycle',
        vehicleNumber: 'XYZ789',
        vehicleLicense: 'https://test.com/license2.jpg',
        userImage: 'https://test.com/profile2.jpg',
      );

      when(() => mockProfileRepo.getUserProfileData())
          .thenAnswer((_) async => Right(specificUserEntity));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Right<ApiException, UserDataEntity>>());

      result.fold(
        (error) => fail('Should return success'),
        (userEntity) {
          // Verify that the exact entity from repository is returned
          expect(userEntity.driverId, equals('specific-id-123'));
          expect(userEntity.userFname, equals('Jane'));
          expect(userEntity.userLname, equals('Smith'));
          expect(userEntity.userEmail, equals('jane.smith@test.com'));
          expect(userEntity.userPhone, equals('+201987654321'));
          expect(userEntity.userGender, equals('female'));
          expect(userEntity.vehicleType, equals('motorcycle'));
          expect(userEntity.vehicleNumber, equals('XYZ789'));
        },
      );

      verify(() => mockProfileRepo.getUserProfileData()).called(1);
    });

    test('should handle repository response time correctly', () async {
      // Arrange
      when(() => mockProfileRepo.getUserProfileData()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return Right(mockUserDataEntity);
      });

      // Act
      final stopwatch = Stopwatch()..start();
      final result = await useCase.call();
      stopwatch.stop();

      // Assert
      expect(result, isA<Right<ApiException, UserDataEntity>>());
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(90));

      verify(() => mockProfileRepo.getUserProfileData()).called(1);
    });
  });
}
