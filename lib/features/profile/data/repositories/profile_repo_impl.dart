import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:flowery_rider/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_request_model.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_response.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/domain/repositories/profile_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _dataSource;
  final AuthLocalDataSource _authLocalDataSource;

  ProfileRepoImpl(this._dataSource, this._authLocalDataSource);

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
  Future<Either<ApiException, void>> updateDriverCarInfo(
      UpdateCarInfoModel updateCarInfoModel, String driverId) async {
    try {
      await _dataSource.updateDriverCarInfo(updateCarInfoModel, driverId);
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
  Future<Either<ApiException, UserDataEntity>> updateUserInfo(
      UpdateUserInfoModel updateUserInfoModel, File? userProfileImage) async {
    try {
      var data = await _dataSource.updateUserInfo(
          updateUserInfoModel, userProfileImage);
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
  Future<Either<ApiException, ChangePasswordResponse>> changePassword(
      ChangePasswordRequestModel changePasswordModel) async {
    try {
      final response = await _dataSource.changePassword(changePasswordModel);
      await _authLocalDataSource.cacheToken(response.token ?? '');
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
  Future<Either<Exception, void>> logout() async {
    try {
      _authLocalDataSource.deleteToken();
      _authLocalDataSource.deleteRememberMe();
      return const Right(null);
    } catch (e) {
      return Left(Exception('Logout failed: ${e.toString()}'));
    }
  }
}
