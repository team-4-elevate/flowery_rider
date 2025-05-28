import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_request_model.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_response.dart';
import 'package:flowery_rider/features/profile/domain/repositories/profile_repo.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class
class MockProfileRepo extends Mock implements ProfileRepo {}

void main() {
  late ChangePasswordUseCase useCase;
  late MockProfileRepo mockProfileRepo;

  setUp(() {
    mockProfileRepo = MockProfileRepo();
    useCase = ChangePasswordUseCase(mockProfileRepo);

    // Register fallback values
    registerFallbackValue(ChangePasswordRequestModel(
      oldPassword: '',
      newPassword: '',
    ));
  });

  group('ChangePasswordUseCase', () {
    final changePasswordRequest = ChangePasswordRequestModel(
      oldPassword: 'oldPassword123',
      newPassword: 'newPassword456',
    );
    final mockChangePasswordResponse = ChangePasswordResponse(
      message: 'Password changed successfully',
      token: 'mockToken123',
    );

    test('should return ChangePasswordResponse when repository call succeeds',
        () async {
      // Arrange
      when(() => mockProfileRepo.changePassword(any()))
          .thenAnswer((_) async => Right(mockChangePasswordResponse));

      // Act
      final result = await useCase.call(changePasswordRequest);

      // Assert
      expect(result, isA<Right<ApiException, ChangePasswordResponse>>());

      result.fold(
        (error) => fail('Should return success'),
        (success) => expect(
            success,
            equals(
                mockChangePasswordResponse)), // Check actual result against expected
      );

      // Verify that the repository method was called with correct parameters
      verify(() => mockProfileRepo.changePassword(changePasswordRequest))
          .called(1);
    });

    test(
        'should return ApiException when repository call fails with general error',
        () async {
      // Arrange
      final apiException = ApiException(
        message: 'Password change failed',
        statusCode: 500,
      );
      when(() => mockProfileRepo.changePassword(any()))
          .thenAnswer((_) async => Left(apiException));

      // Act
      final result = await useCase.call(changePasswordRequest);

      // Assert
      expect(result, isA<Left<ApiException, ChangePasswordResponse>>());
      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, equals('Password change failed'));
          expect(error.statusCode, equals(500));
        },
        (success) => fail('Should return error'),
      );
      verify(() => mockProfileRepo.changePassword(changePasswordRequest))
          .called(1);
    });

    test(
        'should return ApiException when repository returns unauthorized error',
        () async {
      // Arrange
      final unauthorizedException = ApiException(
        message: 'Current password is incorrect',
        statusCode: 401,
      );
      when(() => mockProfileRepo.changePassword(any()))
          .thenAnswer((_) async => Left(unauthorizedException));

      // Act
      final result = await useCase.call(changePasswordRequest);

      // Assert
      expect(result, isA<Left<ApiException, ChangePasswordResponse>>());
      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, equals('Current password is incorrect'));
          expect(error.statusCode, equals(401));
        },
        (success) => fail('Should return error'),
      );
      verify(() => mockProfileRepo.changePassword(changePasswordRequest))
          .called(1);
    });

    test('should return ApiException when repository returns validation error',
        () async {
      // Arrange
      final validationException = ApiException(
        message: 'New password does not meet requirements',
        statusCode: 400,
      );
      when(() => mockProfileRepo.changePassword(any()))
          .thenAnswer((_) async => Left(validationException));

      // Act
      final result = await useCase.call(changePasswordRequest);

      // Assert
      expect(result, isA<Left<ApiException, ChangePasswordResponse>>());
      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(
              error.message, equals('New password does not meet requirements'));
          expect(error.statusCode, equals(400));
        },
        (success) => fail('Should return error'),
      );
      verify(() => mockProfileRepo.changePassword(changePasswordRequest))
          .called(1);
    });

    test('should return ApiException when repository returns network error',
        () async {
      // Arrange
      final networkException = ApiException(
        message: 'Network connection failed',
        statusCode: 0,
      );
      when(() => mockProfileRepo.changePassword(any()))
          .thenAnswer((_) async => Left(networkException));

      // Act
      final result = await useCase.call(changePasswordRequest);

      // Assert
      expect(result, isA<Left<ApiException, ChangePasswordResponse>>());
      result.fold(
        (error) {
          expect(error, isA<ApiException>());
          expect(error.message, equals('Network connection failed'));
          expect(error.statusCode, equals(0));
        },
        (success) => fail('Should return error'),
      );
      verify(() => mockProfileRepo.changePassword(changePasswordRequest))
          .called(1);
    });

    test('should correctly pass different password request models', () async {
      // Arrange
      final differentPasswordRequest = ChangePasswordRequestModel(
        oldPassword: 'currentPass789',
        newPassword: 'newSecurePass321',
      );

      when(() => mockProfileRepo.changePassword(any()))
          .thenAnswer((_) async => Right(mockChangePasswordResponse));

      // Act
      final result = await useCase.call(differentPasswordRequest);

      // Assert
      expect(result, isA<Right<ApiException, ChangePasswordResponse>>());

      result.fold(
        (error) => fail('Should return success'),
        (success) => expect(
            success,
            equals(
                mockChangePasswordResponse)), // Check actual result against expected
      );

      // Verify that the repository was called with the correct different model
      verify(() => mockProfileRepo.changePassword(differentPasswordRequest))
          .called(1);
    });

    test('should handle multiple consecutive calls correctly', () async {
      // Arrange
      when(() => mockProfileRepo.changePassword(any()))
          .thenAnswer((_) async => Right(mockChangePasswordResponse));

      // Act
      final result1 = await useCase.call(changePasswordRequest);
      final result2 = await useCase.call(changePasswordRequest);
      final result3 = await useCase.call(changePasswordRequest);

      // Assert
      expect(result1, isA<Right<ApiException, ChangePasswordResponse>>());
      expect(result2, isA<Right<ApiException, ChangePasswordResponse>>());
      expect(result3, isA<Right<ApiException, ChangePasswordResponse>>());

      // Verify that the repository was called three times
      verify(() => mockProfileRepo.changePassword(changePasswordRequest))
          .called(3);
    });

    test('should handle alternating success and failure calls', () async {
      // Arrange
      final apiException = ApiException(message: 'Temporary error');

      int callCount = 0;
      when(() => mockProfileRepo.changePassword(any())).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) return Right(mockChangePasswordResponse);
        if (callCount == 2) return Left(apiException);
        return Right(mockChangePasswordResponse);
      });

      // Act
      final result1 = await useCase.call(changePasswordRequest);
      final result2 = await useCase.call(changePasswordRequest);
      final result3 = await useCase.call(changePasswordRequest);

      // Assert
      expect(result1, isA<Right<ApiException, ChangePasswordResponse>>());
      expect(result2, isA<Left<ApiException, ChangePasswordResponse>>());
      expect(result3, isA<Right<ApiException, ChangePasswordResponse>>());

      // Verify that the repository was called three times
      verify(() => mockProfileRepo.changePassword(changePasswordRequest))
          .called(3);
    });

    test('should verify request model data integrity', () async {
      // Arrange
      final specificRequest = ChangePasswordRequestModel(
        oldPassword: 'myOldPassword123!',
        newPassword: 'myNewSecurePassword456@',
      );

      when(() => mockProfileRepo.changePassword(any()))
          .thenAnswer((_) async => Right(mockChangePasswordResponse));

      // Act
      final result = await useCase.call(specificRequest);

      // Assert
      expect(result, isA<Right<ApiException, ChangePasswordResponse>>());

      // Capture the argument passed to repository to verify data integrity
      final captured =
          verify(() => mockProfileRepo.changePassword(captureAny())).captured;
      final capturedRequest = captured.first as ChangePasswordRequestModel;

      expect(capturedRequest.oldPassword, equals('myOldPassword123!'));
      expect(capturedRequest.newPassword, equals('myNewSecurePassword456@'));
    });

    test('should handle async repository response timing', () async {
      // Arrange
      when(() => mockProfileRepo.changePassword(any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return Right(mockChangePasswordResponse);
      });

      // Act
      final stopwatch = Stopwatch()..start();
      final result = await useCase.call(changePasswordRequest);
      stopwatch.stop();

      // Assert
      expect(result, isA<Right<ApiException, ChangePasswordResponse>>());
      result.fold(
        (error) => fail('Should return success'),
        (success) => expect(
            success,
            equals(
                mockChangePasswordResponse)), // Check actual result against expected
      );
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(90));

      verify(() => mockProfileRepo.changePassword(changePasswordRequest))
          .called(1);
    });

    test('should handle weak password validation error', () async {
      // Arrange
      final weakPasswordRequest = ChangePasswordRequestModel(
        oldPassword: 'oldpass',
        newPassword: '123',
      );
      final weakPasswordException = ApiException(
        message: 'Password must be at least 8 characters long',
        statusCode: 400,
      );
      when(() => mockProfileRepo.changePassword(any()))
          .thenAnswer((_) async => Left(weakPasswordException));

      // Act
      final result = await useCase.call(weakPasswordRequest);

      // Assert
      expect(result, isA<Left<ApiException, ChangePasswordResponse>>());
      result.fold(
        (error) {
          expect(error.message,
              equals('Password must be at least 8 characters long'));
          expect(error.statusCode, equals(400));
        },
        (success) => fail('Should return validation error'),
      );
      verify(() => mockProfileRepo.changePassword(weakPasswordRequest))
          .called(1);
    });

    test('should handle same password error', () async {
      // Arrange
      final samePasswordRequest = ChangePasswordRequestModel(
        oldPassword: 'samePassword123',
        newPassword: 'samePassword123',
      );
      final samePasswordException = ApiException(
        message: 'New password must be different from current password',
        statusCode: 400,
      );
      when(() => mockProfileRepo.changePassword(any()))
          .thenAnswer((_) async => Left(samePasswordException));

      // Act
      final result = await useCase.call(samePasswordRequest);

      // Assert
      expect(result, isA<Left<ApiException, ChangePasswordResponse>>());
      result.fold(
        (error) {
          expect(error.message,
              equals('New password must be different from current password'));
          expect(error.statusCode, equals(400));
        },
        (success) => fail('Should return validation error'),
      );
      verify(() => mockProfileRepo.changePassword(samePasswordRequest))
          .called(1);
    });
  });
}
