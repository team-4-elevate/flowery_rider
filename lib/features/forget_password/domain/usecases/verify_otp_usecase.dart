import 'package:injectable/injectable.dart';
import '../repo_interface/forget_password_repo_interface.dart';

@injectable
class VerifyOtpUseCase {
  final ForgetPasswordRepoI _repo;

  VerifyOtpUseCase(this._repo);

  Future<void> call(String otp) {
    return _repo.verifyOtp(otp);
  }
}
