// features/auth/data/datasource/remote_data_source/auth_remote_data_source_contract.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/model/apply/apply_request.dart';
import 'package:flowery_rider/features/auth/data/model/apply/apply_response.dart';
import 'package:flowery_rider/features/auth/data/model/login/login_response.dart';

abstract class AuthRemoteDataSourceContract {
  //------------------------------Login-----------------------------------
  Future<Either<ApiException, LoginResponse>> signIn(
      String email, String password);

//------------------------------forgot password-----------------------------------
  Future<Either<ApiException, String>> forgotPassword(String email);

  Future<Either<ApiException, String>> verifyOtpCode(String email, String code);

  Future<Either<ApiException, LoginResponse>> resetPassword(
      String email, String password);

  //------------------------------apply-----------------------------------
  Future<Either<ApiException, ApplyResponse>> apply(ApplyRequest request);
}
