// features/auth/domain/entities/apply_entity.dart

import 'dart:io';
import 'package:flowery_rider/core/app_data/shared_models/orders/driver.dart';

class ApplyEntity {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String countryCode;
  final String gender;
  final String vehicleType;
  final String vehicleNumber;
  final String idNumber;
  final String password;
  final File? licensePhoto;
  final File? idPhoto;

  const ApplyEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.gender,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.idNumber,
    required this.password,
    this.licensePhoto,
    this.idPhoto,
  });

  factory ApplyEntity.fromFormData({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String countryCode,
    required String gender,
    required String vehicleType,
    required String vehicleNumber,
    required String idNumber,
    required String password,
    required File? licensePhoto,
    required File? idPhoto,
  }) {
    return ApplyEntity(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: email.trim().toLowerCase(),
      phone: phone.trim(),
      countryCode: countryCode,
      gender: gender,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber.trim(),
      idNumber: idNumber.trim(),
      password: password,
      licensePhoto: licensePhoto,
      idPhoto: idPhoto,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'countryCode': countryCode,
      'gender': gender,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'idNumber': idNumber,
      'password': password,
    };
  }

  factory ApplyEntity.fromJson(Map<String, dynamic> json) {
    return ApplyEntity(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      countryCode: json['countryCode'],
      gender: json['gender'],
      vehicleType: json['vehicleType'],
      vehicleNumber: json['vehicleNumber'],
      idNumber: json['idNumber'],
      password: json['password'],
    );
  }
  FirebaseDriverDM toFirebaseDriver(ApplyEntity applyEntity) {
    return FirebaseDriverDM(
        id: applyEntity.idNumber,
        name: applyEntity.firstName + applyEntity.lastName,
        phone: phone,
        email: email);
  }
}
