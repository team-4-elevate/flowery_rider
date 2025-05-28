import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/profile/domain/repositories/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase {
final  ProfileRepo _profileRepo;
  LogoutUseCase(this._profileRepo);
  Future<Either<Exception, void>> call() async {
   return await _profileRepo.logout();
  }
}
