import 'package:equatable/equatable.dart';
import 'package:flowery_rider/features/order_details/data/models/location_dm.dart';

class Customer extends Equatable {
  final String? id;
  final String? firstName;
  final String? phone;
  final String? photo;
  final String? address;
  final LocationDM? location;

  const Customer({
    required this.id,
    required this.firstName,
    required this.phone,
    this.photo,
    this.address,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': firstName,
      'phone': phone,
      'photo': photo,
      'address': address,
      'location': location
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, String>?;
    return Customer(
      id: json['_id'] as String?,
      firstName: json['name'] as String?,
      phone: json['phone'] as String?,
      photo: json['photo'] as String?,
      address: json['address'] as String?,
      location: location != null ? LocationDM.fromJson(location) : null,
    );
  }

  @override
  List<Object?> get props => [id, firstName, phone, photo, location];
}
