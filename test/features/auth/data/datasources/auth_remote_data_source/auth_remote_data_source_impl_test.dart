import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_remote_data_source/auth_remote_data_source_impl.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;

  setUp(() {
    mockApiClient = MockApiClient();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(mockApiClient);
  });

  group('AuthRemoteDataSourceImpl.login', () {
    final loginRequest =
        LoginRequset(email: 'test@example.com', password: 'password123');
    final loginResponse = LoginResponse(token: 'dummyToken');

    test('should return LoginResponse when login is successful', () async {
      when(mockApiClient.post(
        ApiConstants.loginEndPoint,
        data: loginRequest.toJson(),
        requiresToken: false,
      )).thenAnswer((_) async => {
            'token': 'dummyToken',
          });

      final result = await authRemoteDataSourceImpl.login(loginRequest);

      expect(result, isA<LoginResponse>());
      expect(result.token, loginResponse.token);
      verify(mockApiClient.post(
        ApiConstants.loginEndPoint,
        data: loginRequest.toJson(),
        requiresToken: false,
      )).called(1);
    });

    test('should throw an exception when login fails', () async {
      when(mockApiClient.post(
        ApiConstants.loginEndPoint,
        data: loginRequest.toJson(),
        requiresToken: false,
      )).thenThrow(Exception('Login failed'));

      expect(() => authRemoteDataSourceImpl.login(loginRequest),
          throwsA(isA<Exception>()));
      verify(mockApiClient.post(
        ApiConstants.loginEndPoint,
        data: loginRequest.toJson(),
        requiresToken: false,
      )).called(1);
    });
  });
}
