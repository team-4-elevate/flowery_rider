import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';

abstract interface class ProfileRepo {
  Future<Either<ApiException , UserDataEntity>> getUserProfileData();
  Future<Either<ApiException , void>> updateUserInfo(
   UpdateUserInfoModel updateUserInfoModel,
     File? userProfileImage,
  );
  Future<Either<ApiException , void>> updateDriverCarInfo(
    UpdateCarInfoModel updateCarInfoModel,
  );
}
