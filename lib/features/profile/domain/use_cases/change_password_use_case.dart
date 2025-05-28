import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_request_model.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_response.dart';
import 'package:flowery_rider/features/profile/domain/repositories/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepo _profileRepository;

  ChangePasswordUseCase(this._profileRepository);

  Future<Either<ApiException, ChangePasswordResponse>> call(
      ChangePasswordRequestModel request) async {
    return await _profileRepository.changePassword(request);
  }
}
