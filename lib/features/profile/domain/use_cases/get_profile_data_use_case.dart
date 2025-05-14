import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/domain/repositories/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfileDataUseCase {
  final ProfileRepo _repo;
  GetProfileDataUseCase(this._repo);
  Future<Either<ApiException, UserDataEntity>> call() async {
    return await _repo.getUserProfileData();
  }
}
