import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final AuthRepo _authRepo;
  LoginUseCase(this._authRepo);

  Future<Either<ApiException, LoginResponse>> call(
      LoginRequset loginRequset, bool rememberMe) async {
    return await _authRepo.login(loginRequset, rememberMe);
  }
}
