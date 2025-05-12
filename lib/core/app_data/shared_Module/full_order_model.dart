// core/app_data/shared_Module/full_order_model.dart
import 'package:equatable/equatable.dart';
import 'driver_order_model.dart';

class FullOrderModel extends Equatable {
  final String? id;
  final String? driverId;
  final DriverOrderModel? order;
  final StoreModel? store;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  const FullOrderModel({
    this.id,
    this.driverId,
    this.order,
    this.store,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FullOrderModel.fromJson(Map<String, dynamic> json) {
    return FullOrderModel(
      id: json['_id'] as String?,
      driverId: json['driver'] as String?,
      order: json['order'] != null
          ? DriverOrderModel.fromJson(json['order'] as Map<String, dynamic>)
          : null,
      store: json['store'] != null
          ? StoreModel.fromJson(json['store'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'driver': driverId,
      'order': order?.toJson(),
      'store': store?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }

  @override
  List<Object?> get props =>
      [id, driverId, order, store, createdAt, updatedAt, v];
}

class StoreModel extends Equatable {
  final String? name;
  final String? image;
  final String? address;
  final String? phoneNumber;
  final String? latLong;

  const StoreModel({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      name: json['name'] as String?,
      image: json['image'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      latLong: json['latLong'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'address': address,
      'phoneNumber': phoneNumber,
      'latLong': latLong,
    };
  }

  @override
  List<Object?> get props => [name, image, address, phoneNumber, latLong];
}
