import 'package:injectable/injectable.dart';
import '../repo_interface/forget_password_repo_interface.dart';

@injectable
class ResendOtpUseCase {
  final ForgetPasswordRepoI _repo;
  ResendOtpUseCase(this._repo);

  Future<void> call(String email) {
    return _repo.forgetPassword(email);
  }
}
