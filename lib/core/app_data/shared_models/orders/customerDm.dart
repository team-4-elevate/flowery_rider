import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;

  const Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.phone,
    this.photo,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'phone': phone,
      'photo': photo,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      phone: json['phone'] as String?,
      photo: json['photo'] as String?,
    );
  }

  @override
  List<Object?> get props =>
      [id, firstName, lastName, email, gender, phone, photo];
}
