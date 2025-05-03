import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';
import 'package:flowery_rider/features/auth/domain/usecases/login_use_case.dart';
import 'package:flowery_rider/features/auth/presentation/pages/login_screen/login_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/pages/login_screen/login_states.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([LoginUseCase, AuthLocalDataSource])
void main() {
  late LoginCubit loginCubit;
  late MockLoginUseCase loginUseCase;
  late MockAuthLocalDataSource authLocalDataSource;

  const email = 'test@example.com';
  const password = 'password123';
  const token = 'mock_token';

  setUpAll(() {
    provideDummy<Either<ApiException, LoginResponse>>(
      Right(LoginResponse(token: token)),
    );
    provideDummy<Either<ApiException, LoginResponse>>(
      Left(ApiException(message: 'Invalid credentials')),
    );
  });

  setUp(() {
    loginUseCase = MockLoginUseCase();
    authLocalDataSource = MockAuthLocalDataSource();
    loginCubit = LoginCubit(loginUseCase, authLocalDataSource);
  });

  group('LoginCubit Tests', () {
    test('initial state is correct', () {
      expect(loginCubit.state.loginStates, isA<BaseInitialState>());
      expect(loginCubit.state.rememberMe, false);
    });

    blocTest<LoginCubit, LoginStates>(
      'emits [Initial, Loading, Success] when login succeeds',
      build: () {
        when(loginUseCase.call(
          argThat(isA<LoginRequset>()),
          any,
        )).thenAnswer((_) async => Right(LoginResponse(token: token)));

        when(authLocalDataSource.cacheToken(token))
            .thenAnswer((_) async => Future.value());

        return loginCubit;
      },
      act: (cubit) {
        cubit.changeRememberMe(true);
        cubit.doLogin(email, password);
      },
      expect: () => [
        isA<LoginStates>()
            .having((s) => s.loginStates, 'loginStates', isA<BaseInitialState>())
            .having((s) => s.rememberMe, 'rememberMe', true),
        isA<LoginStates>()
            .having((s) => s.loginStates, 'loginStates', isA<BaseLoadingState>())
            .having((s) => s.rememberMe, 'rememberMe', true),
        isA<LoginStates>()
            .having((s) => s.loginStates, 'loginStates', isA<BaseSuccessState>())
            .having((s) => s.rememberMe, 'rememberMe', true),
      ],
      verify: (_) {
        verify(loginUseCase.call(
          argThat(isA<LoginRequset>()
              .having((r) => r.email, 'email', email)
              .having((r) => r.password, 'password', password)),
          true,
        )).called(1);
        verify(authLocalDataSource.cacheToken(token)).called(1);
      },
    );

    blocTest<LoginCubit, LoginStates>(
      'emits [Initial, Loading, Error] when login fails',
      build: () {
        when(loginUseCase.call(
          argThat(isA<LoginRequset>()),
          any,
        )).thenAnswer(
          (_) async => Left(ApiException(message: 'Invalid credentials')),
        );
        return loginCubit;
      },
      act: (cubit) {
        cubit.changeRememberMe(false); 
        cubit.doLogin(email, password);
      },
      expect: () => [
        isA<LoginStates>()
            .having((s) => s.loginStates, 'loginStates', isA<BaseInitialState>())
            .having((s) => s.rememberMe, 'rememberMe', false),
        isA<LoginStates>()
            .having((s) => s.loginStates, 'loginStates', isA<BaseLoadingState>())
            .having((s) => s.rememberMe, 'rememberMe', false),
        isA<LoginStates>()
            .having(
              (s) => s.loginStates,
              'loginStates',
              isA<BaseErrorState>()
                  .having((e) => e.errorMessage, 'message', 'Invalid credentials'),
            )
            .having((s) => s.rememberMe, 'rememberMe', false),
      ],
      verify: (_) {
        verify(loginUseCase.call(
          argThat(isA<LoginRequset>()
              .having((r) => r.email, 'email', email)
              .having((r) => r.password, 'password', password)),
          false,
        )).called(1);
      },
    );
  });
}