import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/logout_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late LogoutUseCase useCase;
  late MockAuthLocalDataSource mockAuthLocalDataSource;

  setUp(() {
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    useCase = LogoutUseCase(mockAuthLocalDataSource);
  });

  group('LogoutUseCase', () {
    test(
        'should successfully logout and return Right(null) when both operations succeed',
        () async {
      // Arrange
      when(() => mockAuthLocalDataSource.deleteToken())
          .thenAnswer((_) async {});
      when(() => mockAuthLocalDataSource.deleteRememberMe())
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Right<Exception, void>>());

      result.fold(
        (error) => fail('Should return success'),
        (_) => null,
      );

      // Verify each method was called exactly once
      verify(() => mockAuthLocalDataSource.deleteToken()).called(1);
      verify(() => mockAuthLocalDataSource.deleteRememberMe()).called(1);
    });

    test('should return Left(Exception) when deleteToken fails', () async {
      // Arrange
      when(() => mockAuthLocalDataSource.deleteToken())
          .thenThrow(Exception('Failed to delete token'));
      when(() => mockAuthLocalDataSource.deleteRememberMe())
          .thenAnswer((_) async => {});

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Left<Exception, void>>());

      result.fold(
        (error) {
          expect(error, isA<Exception>());
          expect(error.toString(), contains('Logout failed'));
        },
        (success) => fail('Should return error'),
      );

      // Verify that deleteToken was called but deleteRememberMe might not be reached
      verify(() => mockAuthLocalDataSource.deleteToken()).called(1);
      // Note: deleteRememberMe might not be called due to exception in deleteToken
    });

    test('should return Left(Exception) when deleteRememberMe fails', () async {
      // Arrange
      when(() => mockAuthLocalDataSource.deleteToken())
          .thenAnswer((_) async => {});
      when(() => mockAuthLocalDataSource.deleteRememberMe())
          .thenThrow(Exception('Failed to delete remember me'));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Left<Exception, void>>());

      result.fold(
        (error) {
          expect(error, isA<Exception>());
          expect(error.toString(), contains('Logout failed'));
        },
        (success) => fail('Should return error'),
      );

      // Verify that both methods were attempted to be called
      verify(() => mockAuthLocalDataSource.deleteToken()).called(1);
      verify(() => mockAuthLocalDataSource.deleteRememberMe()).called(1);
    });

    test('should return Left(Exception) when both operations fail', () async {
      // Arrange
      when(() => mockAuthLocalDataSource.deleteToken())
          .thenThrow(Exception('Token deletion failed'));
      when(() => mockAuthLocalDataSource.deleteRememberMe())
          .thenThrow(Exception('Remember me deletion failed'));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Left<Exception, void>>());

      result.fold(
        (error) {
          expect(error, isA<Exception>());
          expect(error.toString(), contains('Logout failed'));
        },
        (success) => fail('Should return error'),
      );

      // Verify that deleteToken was called
      verify(() => mockAuthLocalDataSource.deleteToken()).called(1);
      // deleteRememberMe might not be called if deleteToken throws first
    });

    test('should handle different types of exceptions from deleteToken',
        () async {
      // Arrange
      when(() => mockAuthLocalDataSource.deleteToken())
          .thenThrow(ArgumentError('Invalid token format'));
      when(() => mockAuthLocalDataSource.deleteRememberMe())
          .thenAnswer((_) async => {});

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Left<Exception, void>>());

      result.fold(
        (error) {
          expect(error, isA<Exception>());
          expect(error.toString(), contains('Logout failed'));
        },
        (success) => fail('Should return error'),
      );

      verify(() => mockAuthLocalDataSource.deleteToken()).called(1);
    });

    test('should handle different types of exceptions from deleteRememberMe',
        () async {
      // Arrange
      when(() => mockAuthLocalDataSource.deleteToken())
          .thenAnswer((_) async => {});
      when(() => mockAuthLocalDataSource.deleteRememberMe())
          .thenThrow(StateError('Invalid state'));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Left<Exception, void>>());

      result.fold(
        (error) {
          expect(error, isA<Exception>());
          expect(error.toString(), contains('Logout failed'));
        },
        (success) => fail('Should return error'),
      );

      verify(() => mockAuthLocalDataSource.deleteToken()).called(1);
      verify(() => mockAuthLocalDataSource.deleteRememberMe()).called(1);
    });

    test('should handle multiple consecutive logout calls', () async {
      // Arrange
      when(() => mockAuthLocalDataSource.deleteToken())
          .thenAnswer((_) async => {});
      when(() => mockAuthLocalDataSource.deleteRememberMe())
          .thenAnswer((_) async => {});

      // Act
      final result1 = await useCase.call();
      final result2 = await useCase.call();
      final result3 = await useCase.call();

      // Assert
      expect(result1, isA<Right<Exception, void>>());
      expect(result2, isA<Right<Exception, void>>());
      expect(result3, isA<Right<Exception, void>>());

      // Verify that both methods were called 3 times each
      verify(() => mockAuthLocalDataSource.deleteToken()).called(3);
      verify(() => mockAuthLocalDataSource.deleteRememberMe()).called(3);
    });

    test('should handle async operations correctly', () async {
      // Arrange
      when(() => mockAuthLocalDataSource.deleteToken()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return;
      });
      when(() => mockAuthLocalDataSource.deleteRememberMe())
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return;
      });

      // Act
      final stopwatch = Stopwatch()..start();
      final result = await useCase.call();
      stopwatch.stop();

      // Assert
      expect(result, isA<Right<Exception, void>>());
      // Should take at least 150ms (100ms + 50ms) since operations are sequential
      expect(stopwatch.elapsedMilliseconds,
          greaterThanOrEqualTo(140)); // Some tolerance

      verify(() => mockAuthLocalDataSource.deleteToken()).called(1);
      verify(() => mockAuthLocalDataSource.deleteRememberMe()).called(1);
    });

    test('should maintain operation order when one operation is slower',
        () async {
      // Arrange
      final callOrder = <String>[];

      when(() => mockAuthLocalDataSource.deleteToken()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        callOrder.add('deleteToken');
      });
      when(() => mockAuthLocalDataSource.deleteRememberMe())
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        callOrder.add('deleteRememberMe');
      });

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Right<Exception, void>>());
      expect(callOrder, equals(['deleteToken', 'deleteRememberMe']));

      verifyInOrder([
        () => mockAuthLocalDataSource.deleteToken(),
        () => mockAuthLocalDataSource.deleteRememberMe(),
      ]);
    });
  });
}
