import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_request_model.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/change_password_response.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_car_info.dart';
import 'package:flowery_rider/features/profile/data/models/update_profile_models/update_user_info.dart';
import 'package:flowery_rider/features/profile/data/models/user_data_model/user_data_model.dart';
import 'package:http_parser/http_parser.dart';
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
      UpdateCarInfoModel updateCarInfoModel, String driverId) async {
    await _apiClient.put(
      '${ApiConstants.updateVehicleInfo}/$driverId',
      requiresToken: true,
      data: updateCarInfoModel.toJson(),
    );
  }

  @override
  Future<UserDataModel> updateUserInfo(
    UpdateUserInfoModel updateUserInfoModel,
    File? userProfileImage,
  ) async {
    if (userProfileImage != null) {
      await _apiClient.put(
        ApiConstants.uploadProfileImage,
        requiresToken: true,
        data: FormData.fromMap({
          'photo': await MultipartFile.fromFile(
            userProfileImage.path,
            contentType: MediaType.parse('image/jpeg'),
            filename: userProfileImage.path.split('/').last,
          ),
        }),
      );
    }

    var response = await _apiClient.put(
      ApiConstants.updateDriverProfile,
      requiresToken: true,
      data: updateUserInfoModel.toJson(),
    );

    return UserDataModel.fromJson(response);
  }

  @override
  Future<ChangePasswordResponse> changePassword(
      ChangePasswordRequestModel changePasswordRequestModel) async {
    var response = await _apiClient.patch(
      ApiConstants.changePassword,
      requiresToken: true,
      data: changePasswordRequestModel.toJson(),
    );
    return ChangePasswordResponse.fromJson(response);
  }
}
