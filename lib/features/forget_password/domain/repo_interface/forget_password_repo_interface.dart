abstract interface class ForgetPasswordRepoI {
  Future<void> forgetPassword(String email);
  Future<void> verifyOtp(String otp);
  Future<void> resetPassword(String email, String newPassword);
}
