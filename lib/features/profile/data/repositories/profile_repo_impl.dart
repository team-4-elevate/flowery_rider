import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/domain/repositories/profile_repo.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _dataSource;

  ProfileRepoImpl(this._dataSource);

  @override
  Future<Either<ApiException, UserDataEntity>> getUserProfileData() async {
    try {
      var data = await _dataSource.getUserProfileData();
      final response = UserDataEntity.fromDriver(data.driver);
      return Right(response);
    } catch (e) {
      return Left(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<ApiException, void>> updateDriverCarInfo(UpdateCarInfoModel updateCarInfoModel) async{
    try {
    await _dataSource.updateDriverCarInfo(updateCarInfoModel);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<ApiException, void>> updateUserInfo(UpdateUserInfoModel updateUserInfoModel, File? userProfileImage) async{
    try {
     await _dataSource.updateUserInfo(updateUserInfoModel, userProfileImage);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }
}
