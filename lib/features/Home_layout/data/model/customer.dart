// features/Home_layout/data/model/customer.dart
class Customer {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? phone;
  String? photo;

  Customer({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['_id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        gender: json['gender'] as String?,
        phone: json['phone'] as String?,
        photo: json['photo'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'gender': gender,
        'phone': phone,
        'photo': photo,
      };
}
