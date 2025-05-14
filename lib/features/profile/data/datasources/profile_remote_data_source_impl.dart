import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/data/models/user_data_model/user_data_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;
  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserDataModel> getUserProfileData() async {
    final response = await _apiClient.get(
      ApiConstants.getDriverProfile,
      requiresToken: true,
    );
    return UserDataModel.fromJson(response);
  }

  @override
  Future<void> updateDriverCarInfo(
      UpdateCarInfoModel updateCarInfoModel) async {
    await _apiClient.put(
      ApiConstants.updateDriverProfile,
      requiresToken: true,
      data: updateCarInfoModel.toJson(),
    );
  }

  @override
Future<void> updateUserInfo(
  UpdateUserInfoModel updateUserInfoModel,
  File? userProfileImage,
) async {
  final futures = <Future>[];

  futures.add(
    _apiClient.put(
      ApiConstants.updateDriverProfile,
      requiresToken: true,
      data: updateUserInfoModel.toJson(),
    ),
  );

  if (userProfileImage != null) {
    futures.add(
      _apiClient.put(
        ApiConstants.uploadProfileImage,
        requiresToken: true,
        data: FormData.fromMap({
          'photo': await MultipartFile.fromFile(userProfileImage.path),
        }),
      ),
    );
  }

  await Future.wait(futures);
}

}
