import 'package:flowery_rider/features/forget_password/domain/repo_interface/forget_password_repo_interface.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResetPasswordUseCase {
  final ForgetPasswordRepoI _forgetRepo;

  ResetPasswordUseCase(this._forgetRepo);
  Future<void> call(
      {required String email, required String newPassword}) async {
    await _forgetRepo.resetPassword(email, newPassword);
  }
}
