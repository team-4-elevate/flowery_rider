import 'package:equatable/equatable.dart';
import 'package:flowery_rider/features/order_details/domain/entities/order_status_enum.dart';
import 'location_dm.dart';

class OrderFirestoreDM extends Equatable {
  final String orderId;
  final String userId;
  final String? driverId;
  final OrderStatusEnum status;
  final DateTime? estimatedArrival;
  final DateTime? createdAt;
  final LocationDM? riderLocation;

  const OrderFirestoreDM({
    required this.orderId,
    required this.userId,
    required this.status,
    this.riderLocation,
    this.driverId,
    this.estimatedArrival,
    this.createdAt,
  });

  factory OrderFirestoreDM.fromJson(Map<String, dynamic> json) {
    final locationData = json['location'] as Map<dynamic, dynamic>?;

    return OrderFirestoreDM(
      orderId: json['orderId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      driverId: json['driverId'] as String?,
      status: (json['status'] as String? ?? 'pending').toOrderStatusEnum(),
      estimatedArrival: json['estimatedArrival'] != null
          ? DateTime.parse(json['estimatedArrival']! as String)
          : null,
      riderLocation: locationData != null
          ? LocationDM.fromJson(Map<String, dynamic>.from(locationData))
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']! as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'status': status,
      if (driverId != null) 'driverId': driverId,
      if (estimatedArrival != null)
        'estimatedArrival': estimatedArrival!.toIso8601String(),
      if (riderLocation != null) 'location': riderLocation!.toJson(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  OrderFirestoreDM copyWith({
    String? orderId,
    String? userId,
    String? driverId,
    OrderStatusEnum? status,
    double? totalPrice,
    DateTime? createdAt,
    DateTime? estimatedArrival,
    LocationDM? location,
  }) {
    return OrderFirestoreDM(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      driverId: driverId ?? this.driverId,
      estimatedArrival: estimatedArrival ?? this.estimatedArrival,
      status: status ?? this.status,
      riderLocation: location ?? riderLocation,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory OrderFirestoreDM.initial() => OrderFirestoreDM(
        orderId: '',
        userId: '',
        status: OrderStatusEnum.pending,
      );

  @override
  List<Object?> get props => [
        orderId,
        userId,
        driverId,
        status,
        estimatedArrival,
        riderLocation,
        createdAt
      ];

  bool get isAccepted => status == OrderStatusEnum.accepted;
  bool get isPickedUp => status == OrderStatusEnum.pickedUp;
  bool get isPending => status == OrderStatusEnum.pending;
  bool get isOutForDelivery => status == OrderStatusEnum.outForDelivery;
  bool get isDelivered => status == OrderStatusEnum.delivered;
}
