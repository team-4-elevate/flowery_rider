import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';
import 'package:injectable/injectable.dart';

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
}
