import '../../models/reset_password_response.dart';

abstract interface class ForgetPasswordRemoteDsI {
  Future<void> forgetPassword(String email);
  Future<void> verifyOtp(String otp);
  Future<ResetPasswordResponseModel> resetPassword(
      {required String email, required String newPassword});
}
