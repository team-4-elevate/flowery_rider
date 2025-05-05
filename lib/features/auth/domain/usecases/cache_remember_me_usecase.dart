import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class CacheRememberMeUsecase {
  final AuthRepo _authRepo;
  CacheRememberMeUsecase(this._authRepo);

  Future<Either<ApiException, bool>> call(bool rememberMe) async {
    return await _authRepo.cacheRememberMe(rememberMe);
  }
}
