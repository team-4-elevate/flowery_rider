import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';
import 'package:flowery_rider/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([AuthRemoteDataSource, AuthLocalDataSource])
import 'auth_repo_impl_test.mocks.dart';

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late AuthRepoImpl authRepo;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    authRepo = AuthRepoImpl(
      mockRemoteDataSource,
    );
  });

  group('AuthRepoImpl.login', () {
    final loginRequest =
        LoginRequset(email: 'test@example.com', password: 'password123');
    final loginResponse = LoginResponse(token: 'dummyToken');

    test('should return LoginResponse when login is successful', () async {
      when(mockRemoteDataSource.login(loginRequest))
          .thenAnswer((_) async => loginResponse);

      final result = await authRepo.login(loginRequest, true);

      expect(result.isRight, true);
      expect(result.right, loginResponse);
      verify(mockRemoteDataSource.login(loginRequest)).called(1);
    });

    test('should return ApiException when an API exception occurs', () async {
      when(mockRemoteDataSource.login(loginRequest))
          .thenThrow(ApiException(message: 'API error'));

      final result = await authRepo.login(loginRequest, true);

      expect(result.isLeft, true);
      expect(result.left, isA<ApiException>());
      verify(mockRemoteDataSource.login(loginRequest)).called(1);
    });
  });
}
