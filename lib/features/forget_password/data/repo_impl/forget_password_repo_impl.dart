import 'dart:developer';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/forget_password/data/models/reset_password_response.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repo_interface/forget_password_repo_interface.dart';
import '../data_sources/local_data_source/forget_password_local_sd_i.dart';
import '../data_sources/remote_data_source/forget_password_remote_ds_i.dart';

@Injectable(as: ForgetPasswordRepoI)
class ForgetPasswordRepoImpl implements ForgetPasswordRepoI {
  final ForgetPasswordRemoteDsI _forgetPasswordRemoteDs;
  final ForgetPasswordLocalDsI _forgetPasswordLocalDs;

  ForgetPasswordRepoImpl(
      this._forgetPasswordRemoteDs, this._forgetPasswordLocalDs);
  @override
  Future<void> forgetPassword(String email) async {
    await _forgetPasswordRemoteDs.forgetPassword(email);
  }

  @override
  Future<void> verifyOtp(String otp) async {
    return await _forgetPasswordRemoteDs.verifyOtp(otp);
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword(
      String email, String newPassword) async {
    final res = await _forgetPasswordRemoteDs.resetPassword(
        email: email, newPassword: newPassword);
    if (res.token == null) {
      log('null token from api');
      throw (ApiException(message: LocaleKeys.somethingWentWrong));
    }
    await _forgetPasswordLocalDs.saveResetPasswordToken(res.token!);
    return res;
  }
}
