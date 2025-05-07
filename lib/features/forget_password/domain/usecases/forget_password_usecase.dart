import 'package:flowery_rider/features/forget_password/domain/repo_interface/forget_password_repo_interface.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordUseCase {
  final ForgetPasswordRepoI _repo;

  ForgetPasswordUseCase(this._repo);

  Future<void> call(String email) async =>
      await _repo.forgetPassword(email);
}
