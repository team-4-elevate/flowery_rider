// features/apply/data/datasource/remote_data_source/auth_remote_data_source_impl.dart

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/core/logger/app_logger.dart';
import 'package:flowery_rider/features/apply/data/datasource/remote_data_source/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/features/apply/data/model/apply/apply_request.dart';
import 'package:flowery_rider/features/apply/data/model/apply/apply_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);


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
