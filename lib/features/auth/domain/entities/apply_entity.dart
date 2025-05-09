// features/auth/domain/entities/apply_entity.dart
import 'dart:io';

/// Domain entity representing application data for a rider
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
  
  /// Factory method to create an entity from form data
  /// This approach maintains clean architecture by keeping the mapping logic
  /// in the data layer conceptually, while not requiring a new file
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
    // Data cleaning and transformation - this would ideally be in a mapper class
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
  
  /// Convert entity to a map - useful for API requests
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
      // Files would need special handling for API requests
    };
  }
}
