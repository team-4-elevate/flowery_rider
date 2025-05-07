// features/auth/data/datasource/remote_data_source/auth_remote_data_source_impl.dart

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/core/logger/app_logger.dart';
import 'package:flowery_rider/features/auth/data/datasource/remote_data_source/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/features/auth/data/model/apply/apply_request.dart';
import 'package:flowery_rider/features/auth/data/model/apply/apply_response.dart';
import 'package:flowery_rider/features/auth/data/model/forgetpassword/forgetpassword_response.dart';
import 'package:flowery_rider/features/auth/data/model/forgetpassword/verifypassword_response.dart';
import 'package:flowery_rider/features/auth/data/model/login/login_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

//---------------------------------signIn-----------------------------------
  @override
  Future<Either<ApiException, LoginResponse>> signIn(
      String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.loginEndPoint,
        data: {
          'email': email,
          'password': password,
        },
        requiresToken: false,
      );

      final signInResponse = LoginResponse.fromJson(response);
      return Right(signInResponse);
    } catch (e) {
      Log.e('Error during sign in: $e');
      return Left(ApiException(message: 'Failed to sign in: $e'));
    }
  }

//---------------------------------forgotPassword-----------------------------------
  @override
  Future<Either<ApiException, String>> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.forgetPasswordEndPoint,
        data: {
          'email': email,
        },
        requiresToken: false,
      );

      final forgotPassResponse = ForgetpasswordResponse.fromJson(response);

      if (forgotPassResponse.message != null) {
        return Right(forgotPassResponse.message!);
      } else {
        return Left(ApiException(message: 'Failed to request password reset'));
      }
    } catch (e) {
      Log.e('Error during forgot password request: $e');
      return Left(
          ApiException(message: 'Failed to request password reset: $e'));
    }
  }

//---------------------------------verifyOtpCode-----------------------------------
  @override
  Future<Either<ApiException, String>> verifyOtpCode(
      String email, String code) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.verifyPasswordEndPoint,
        data: {
          'email': email,
          'resetCode': code,
        },
        requiresToken: false,
      );

      final verifyResponse = VerifypasswordResponse.fromJson(response);

      if (verifyResponse.status != null) {
        return Right(verifyResponse.status!);
      } else {
        return Left(ApiException(message: 'Failed to verify OTP code'));
      }
    } catch (e) {
      Log.e('Error during OTP verification: $e');
      return Left(ApiException(message: 'Failed to verify OTP code: $e'));
    }
  }

//---------------------------------resetPassword-----------------------------------
  @override
  Future<Either<ApiException, LoginResponse>> resetPassword(
      String email, String password) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.resetPasswordEndPoint,
        data: {
          'email': email,
          'newPassword': password,
        },
        requiresToken: false,
      );

      final resetResponse = LoginResponse.fromJson(response);
      return Right(resetResponse);
    } catch (e) {
      Log.e('Error during password reset: $e');
      return Left(ApiException(message: 'Failed to reset password: $e'));
    }
  }

  @override
  Future<Either<ApiException, ApplyResponse>> apply(
      ApplyRequest request) async {
    try {
      final formData = await request.toFormData();

      final response = await _apiClient.post(
        ApiConstants.applyDriverEndPoint,
        data: formData,
        requiresToken: false,
      );

      return Right(ApplyResponse.fromJson(response));
    } catch (e) {
      Log.e('Error during driver application: $e');
      return Left(ApiException(message: 'Failed to submit application: $e'));
    }
  }
}
