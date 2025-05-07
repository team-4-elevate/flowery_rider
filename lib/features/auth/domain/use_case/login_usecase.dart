// features/auth/domain/use_case/login_usecase.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/auth/data/model/login/login_response.dart';
import '../repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final AuthRepo _authRepo;

  LoginUseCase(this._authRepo);

  Future<Either<Exception, LoginResponse>> call(
      String email, String password, bool rememberMe) async {
    return await _authRepo.signIn(email, password, rememberMe);
  }
}
