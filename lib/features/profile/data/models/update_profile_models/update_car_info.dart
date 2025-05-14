import 'dart:io';

import 'package:equatable/equatable.dart';

class UpdateCarInfoModel extends Equatable {
  
 final String? vehicleType;
 final String? vehicleNumber;
 final File? vehicleLicense;

 const UpdateCarInfoModel({
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'vehicleLicense': vehicleLicense,
    };
  }
 
  @override
  List<Object?> get props => [
    vehicleType,
    vehicleNumber,
    vehicleLicense,
  ];
}
