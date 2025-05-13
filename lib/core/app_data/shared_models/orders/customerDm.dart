import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String? id;
  final String? firstName;
  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;
  final String? address;

  const Customer({
    required this.id,
    required this.firstName,
    required this.email,
    required this.phone,
    this.gender,
    this.photo,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': firstName,
      'email': email,
      'gender': gender,
      'phone': phone,
      'photo': photo,
      'address': address,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      phone: json['phone'] as String?,
      photo: json['photo'] as String?,
      address: json['address'] as String?,
    );
  }

  @override
  List<Object?> get props =>
      [id, firstName, email, gender, phone, photo];
}
