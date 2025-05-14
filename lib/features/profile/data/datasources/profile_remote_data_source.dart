import 'dart:io';

import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/data/models/user_data_model/user_data_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserDataModel> getUserProfileData();
  Future<void> updateUserInfo(
    UpdateUserInfoModel updateUserInfoModel,
    File? userProfileImage,
  );
  Future<void> updateDriverCarInfo(
    UpdateCarInfoModel updateCarInfoModel,
  );
}
