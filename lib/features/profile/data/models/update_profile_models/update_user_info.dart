import 'dart:io';

import 'package:equatable/equatable.dart';

class UpdateUserInfoModel extends Equatable {
  final String? fName;
  final String? lName;
  final String? email;
  final String? phone;
  final String? userProfileImage;

  const UpdateUserInfoModel(
      {this.fName, this.lName, this.email, this.userProfileImage, this.phone});

  // UpdateUserInfo formJson(Map<String, dynamic> json) {
  //   return UpdateUserInfo(
  //     fName: json['firstName'],
  //     lName: json['lastName'],
  //     email: json['email'],
  //     userProfileImage: json['photo'],
  //     phone: json['phone'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'firstName': fName,
      'lastName': lName,
      'email': email,
      // 'photo': userProfileImage,
      'phone': phone,
    };
  }

  @override
  List<Object?> get props => [fName, lName, email, userProfileImage, phone];
}
