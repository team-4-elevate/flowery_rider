// features/auth/domain/use_case/forgetpassword_usecase.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/auth/data/model/forgetpassword/resetpassword_response.dart';
import 'package:flowery_rider/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

// Forgot Password Use Case
@injectable
class ForgotPasswordUseCase {
  final AuthRepo _authRepo;

  ForgotPasswordUseCase(this._authRepo);

  Future<Either<Exception, String>> call(String email) async {
    return await _authRepo.forgotPassword(email);
  }
}

// Verify OTP Code Use Case
@injectable
class VerifyOtpCodeUseCase {
  final AuthRepo _authRepo;

  VerifyOtpCodeUseCase(this._authRepo);

  Future<Either<Exception, String>> call(String email, String code) async {
    return await _authRepo.verifyOtpCode(email, code);
  }
}

// Reset Password Use Case
@injectable
class ResetPasswordUseCase {
  final AuthRepo _authRepo;

  ResetPasswordUseCase(this._authRepo);

  Future<Either<Exception, ResetpasswordResponse>> call(
      String email, String password) async {
    return await _authRepo.resetPassword(email, password);
  }
}
