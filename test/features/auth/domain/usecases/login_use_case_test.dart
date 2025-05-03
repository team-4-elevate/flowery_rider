import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo.dart';
import 'package:flowery_rider/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'login_use_case_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late MockAuthRepo mockAuthRepo;
  late LoginUseCase loginUseCase;

  provideDummy<Either<ApiException, LoginResponse>>(
        Right(LoginResponse(message: 'dummyMessage', token: 'dummyToken')),
  );

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    loginUseCase = LoginUseCase(mockAuthRepo);
  });

  group('LoginUseCase Tests', () {
    final loginRequest = LoginRequset(email: 'test@example.com', password: 'password123');
    final loginResponse = LoginResponse(token: 'dummyToken');
    final apiException = ApiException(message: 'Invalid credentials');

    test('should return LoginResponse when login is successful', () async {
      when(mockAuthRepo.login(loginRequest, true))
          .thenAnswer((_) async => Right(loginResponse));

      final result = await loginUseCase.call(loginRequest, true);

      expect(result.isRight, true);
      expect(result.right, loginResponse);
      verify(mockAuthRepo.login(loginRequest, true)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test('should return ApiException when login fails', () async {
      when(mockAuthRepo.login(loginRequest, false))
          .thenAnswer((_) async => Left(apiException));

      final result = await loginUseCase.call(loginRequest, false);

      expect(result.isLeft, true);
      expect(result.left, apiException);
      verify(mockAuthRepo.login(loginRequest, false)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });
  });
}