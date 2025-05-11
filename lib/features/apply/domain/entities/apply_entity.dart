// features/auth/domain/entities/apply_entity.dart
import 'dart:io';

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
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      countryCode: countryCode,
      gender: gender,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      idNumber: idNumber,
      password: password,
      licensePhoto: licensePhoto,
      idPhoto: idPhoto,
    );
  }
}
