import 'dart:io';

import 'package:flowery_rider/features/profile/data/models/user_data_model/driver.dart';

class UserDataEntity {
  final String userLname;
  final String userFname;
  final String userPhone;
  final String userEmail;
  final String userGender;
  final String vehicleType;
  final String vehicleNumber;
  final String vehicleLicense;
  final String? userImage;

  UserDataEntity({
    required this.userLname,
    required this.userFname,
    required this.userPhone,
    required this.userEmail,
    required this.userGender,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleLicense,
    this.userImage,
  });

  // // You can use this if you want to convert back to Driver, but usually not needed unless uploading
  // Map<String, dynamic> toMap() {
  //   return {
  //     "lastName": userLname,
  //     "firstName": userFname,
  //     "phone": userPhone,
  //     "email": userEmail,
  //     "gender": userGender,
  //     "vehicleType": vehicleType,
  //     "vehicleNumber": vehicleNumber,
  //     "vehicleLicense": vehicleLicense.path, // Usually path for upload
  //   };
  // }

  // Static method to create entity from Driver model
  static UserDataEntity fromDriver(DriverData? driver) {
    return UserDataEntity(
      userLname: driver?.lastName ?? '',
      userFname: driver?.firstName ?? '',
      userPhone: driver?.phone ?? '',
      userEmail: driver?.email ?? '',
      userGender: driver?.gender ?? '',
      vehicleType: driver?.vehicleType ?? '',
      vehicleNumber: driver?.vehicleNumber ?? '',
      vehicleLicense: driver?.vehicleLicense ?? '',
      userImage: driver?.photo??'',
    );
  }
}
