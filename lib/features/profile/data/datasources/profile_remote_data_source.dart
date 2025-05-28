import 'dart:io';

import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_request_model.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_response.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/data/models/user_data_model/user_data_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserDataModel> getUserProfileData();
  Future<UserDataModel> updateUserInfo(
    UpdateUserInfoModel updateUserInfoModel,
    File? userProfileImage,
  );
  Future<void> updateDriverCarInfo(
    UpdateCarInfoModel updateCarInfoModel,
    String driverId,
  );
  Future<ChangePasswordResponse> changePassword(
      ChangePasswordRequestModel changePasswordModel);
}
