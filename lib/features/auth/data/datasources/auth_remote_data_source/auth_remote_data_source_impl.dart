// features/auth/data/datasources/auth_remote_data_source/auth_remote_data_source_impl.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:flowery_rider/features/auth/data/models/apply/apply_request.dart';
import 'package:flowery_rider/features/auth/data/models/apply/apply_response.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/logger/app_logger.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);
  @override
  Future<LoginResponse> login(LoginRequset loginRequset) async {
    var response = await _apiClient.post(
      ApiConstants.loginEndPoint,
      data: loginRequset.toJson(),
      requiresToken: false,
    );
    var loginResponse = LoginResponse.fromJson(response);
    return loginResponse;
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
