import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';
import 'package:injectable/injectable.dart';

import '../../models/reset_password_response.dart';
import 'forget_password_remote_ds_i.dart';

@Injectable(as: ForgetPasswordRemoteDsI)
class ForgetPasswordRemoteDsImpl implements ForgetPasswordRemoteDsI {
  final ApiClient _apiClient;

  ForgetPasswordRemoteDsImpl(this._apiClient);

  @override
  Future<void> forgetPassword(String email) async {
    return await _apiClient.post(
      ApiConstants.forgetPassword,
      data: {'email': email},
      requiresToken: false,
    );
  }

  @override
  Future<void> verifyOtp(String otp) async {
    return await _apiClient.post(
      ApiConstants.verifyOtp,
      data: {'resetCode': otp},
      requiresToken: false,
    );
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword(
      {required String email, required String newPassword}) async {
    final res = await _apiClient.put(
      ApiConstants.resetPassword,
      data: {'email': email, 'newPassword': newPassword},
      requiresToken: false,
    );
    return ResetPasswordResponseModel.fromJson(res);
  }
}
