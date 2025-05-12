// features/profile/data/profile/driver.dart

class Driver {
  String? id;
  String? country;
  String? firstName;
  String? lastName;
  String? vehicleType;
  String? vehicleNumber;
  String? vehicleLicense;
  String? nid;
  String? nidImg;
  String? email;
  String? gender;
  String? phone;
  String? photo;
  String? role;
  DateTime? createdAt;
  String? passwordResetCode;
  DateTime? passwordResetExpires;
  bool? resetCodeVerified;

  Driver({
    this.id,
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nid,
    this.nidImg,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.createdAt,
    this.passwordResetCode,
    this.passwordResetExpires,
    this.resetCodeVerified,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json['_id'] as String?,
        country: json['country'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        vehicleType: json['vehicleType'] as String?,
        vehicleNumber: json['vehicleNumber'] as String?,
        vehicleLicense: json['vehicleLicense'] as String?,
        nid: json['NID'] as String?,
        nidImg: json['NIDImg'] as String?,
        email: json['email'] as String?,
        gender: json['gender'] as String?,
        phone: json['phone'] as String?,
        photo: json['photo'] as String?,
        role: json['role'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        passwordResetCode: json['passwordResetCode'] as String?,
        passwordResetExpires: json['passwordResetExpires'] == null
            ? null
            : DateTime.parse(json['passwordResetExpires'] as String),
        resetCodeVerified: json['resetCodeVerified'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'country': country,
        'firstName': firstName,
        'lastName': lastName,
        'vehicleType': vehicleType,
        'vehicleNumber': vehicleNumber,
        'vehicleLicense': vehicleLicense,
        'NID': nid,
        'NIDImg': nidImg,
        'email': email,
        'gender': gender,
        'phone': phone,
        'photo': photo,
        'role': role,
        'createdAt': createdAt?.toIso8601String(),
        'passwordResetCode': passwordResetCode,
        'passwordResetExpires': passwordResetExpires?.toIso8601String(),
        'resetCodeVerified': resetCodeVerified,
      };
}
