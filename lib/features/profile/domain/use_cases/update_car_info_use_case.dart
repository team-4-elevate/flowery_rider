import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/domain/repositories/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateCarInfoUseCase {
  final ProfileRepo _repo;
  UpdateCarInfoUseCase(this._repo);

  Future<Either<ApiException, void>> call(UpdateCarInfoModel updateCarInfoModel) async {
   return  await _repo.updateDriverCarInfo(updateCarInfoModel);
  }
}
