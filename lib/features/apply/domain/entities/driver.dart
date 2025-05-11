// features/auth/domain/entities/driver.dart

/// Legacy Driver class - used for backward compatibility
class Driver {
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
  String? id;
  DateTime? createdAt;

  Driver({
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
    this.id,
    this.createdAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
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
        id: json['_id'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
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
        '_id': id,
        'createdAt': createdAt?.toIso8601String(),
      };
}
