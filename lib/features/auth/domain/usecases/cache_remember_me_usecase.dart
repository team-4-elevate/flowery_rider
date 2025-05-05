import 'package:flowery_rider/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class CacheRememberMeUsecase {
  final AuthRepo _authRepo;
  CacheRememberMeUsecase(this._authRepo);

  Future<bool> call(bool rememberMe) async {
    return await _authRepo.cacheRememberMe(rememberMe);
  }
}
