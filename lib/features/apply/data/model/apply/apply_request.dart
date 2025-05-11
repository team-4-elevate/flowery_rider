// features/apply/data/model/apply/apply_request.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/features/apply/domain/entities/apply_entity.dart';
import 'package:http_parser/http_parser.dart';

class ApplyRequest {
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

  ApplyRequest({
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

  factory ApplyRequest.fromEntity(ApplyEntity entity) {
    return ApplyRequest(
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      countryCode: entity.countryCode,
      gender: entity.gender,
      vehicleType: entity.vehicleType,
      vehicleNumber: entity.vehicleNumber,
      idNumber: entity.idNumber,
      password: entity.password,
      licensePhoto: entity.licensePhoto,
      idPhoto: entity.idPhoto,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'country_code': countryCode,
      'gender': gender,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'id_number': idNumber,
      'password': password,
    };
  }

  Future<FormData> toFormData() async {
    final String formattedNID = Validator.formatNationalID(idNumber);

    //final String formattedPhone = Validator.formatPhoneForApi(phone);

    final String validVehicleTypeId = Validator.isValidObjectId(vehicleType)
        ? vehicleType
        : Validator.getDefaultVehicleTypeId();

    final formData = FormData();
    String fullInternationalPhone;

    if (phone.startsWith('01')) {
      fullInternationalPhone = '+20${phone.substring(1)}';
    } else if (phone.startsWith('1')) {
      fullInternationalPhone = '+20$phone';
    } else {
      String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleaned.startsWith('0')) {
        cleaned = cleaned.substring(1);
      }
      fullInternationalPhone = '+20$cleaned';
    }

    String countryCode2Letter = 'EG';

    formData.fields.addAll([
      MapEntry('country', countryCode2Letter),
      MapEntry('firstName', firstName),
      MapEntry('lastName', lastName),
      MapEntry('vehicleType', validVehicleTypeId),
      MapEntry('vehicleNumber', vehicleNumber),
      MapEntry('NID', formattedNID),
      MapEntry('email', email),
      MapEntry('password', password),
      MapEntry('rePassword', password),
      MapEntry('gender', gender),
      MapEntry('phone', fullInternationalPhone),
    ]);

    if (licensePhoto != null) {
      final licenseFile = await MultipartFile.fromFile(
        licensePhoto!.path,
        filename: 'license.jpg',
        contentType: MediaType.parse('image/jpeg'),
      );
      formData.files.add(MapEntry('vehicleLicense', licenseFile));
    }

    if (idPhoto != null) {
      final idFile = await MultipartFile.fromFile(
        idPhoto!.path,
        filename: 'id.jpg',
        contentType: MediaType.parse('image/jpeg'),
      );

      formData.files.add(MapEntry('NIDImg', idFile));
    }

    return formData;
  }
}
