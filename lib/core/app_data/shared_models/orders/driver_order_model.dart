// core/app_data/shared_models/orders/driver_order_model.dart
import 'package:equatable/equatable.dart';
import 'package:flowery_rider/features/order_details/domain/entities/payment_type_enum.dart';
import 'customerDm.dart';
import 'order_item.dart';

class DriverOrderModel extends Equatable {
  final String? id;
  final Customer? customer;
  final List<OrderItem>? orderItems;
  final double? totalPrice;
  final PaymentTypeEnum? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;
  final String? createdAt;
  final String? updatedAt;
  final String? orderNumber;
  final int? version;

  const DriverOrderModel({
     this.id,
     this.customer,
     this.orderItems,
     this.totalPrice,
     this.paymentType,
     this.isPaid,
     this.isDelivered,
     this.state,
     this.createdAt,
     this.updatedAt,
     this.orderNumber,
     this.version,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': customer?.toJson(),
      'orderItems': orderItems?.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'paymentType': paymentType,
      'isPaid': isPaid,
      'isDelivered': isDelivered,
      'state': state,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'orderNumber': orderNumber,
      '__v': version,
    };
  }

  factory DriverOrderModel.fromJson(Map<String, dynamic> json) {
    return DriverOrderModel(
      id: json['_id'] as String,
      customer: Customer.fromJson(json['user'] as Map<String, dynamic>),
      orderItems: (json['orderItems'] as List?)
          ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      paymentType: (json['paymentType'] as String?)?.toOrderStatusEnum(),
      isPaid: json['isPaid'] as bool?,
      isDelivered: json['isDelivered'] as bool?,
      state: json['state'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      orderNumber: json['orderNumber'] as String?,
      version: json['__v'] as int?,
    );
  }

  // Create a copy with updated values
  DriverOrderModel copyWith({
    String? id,
    Customer? customer,
    List<OrderItem>? orderItems,
    double? totalPrice,
    PaymentTypeEnum? paymentType,
    bool? isPaid,
    bool? isDelivered,
    String? state,
    String? createdAt,
    String? updatedAt,
    String? orderNumber,
    int? version,
  }) {
    return DriverOrderModel(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      orderItems: orderItems ?? this.orderItems,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentType: paymentType ?? this.paymentType,
      isPaid: isPaid ?? this.isPaid,
      isDelivered: isDelivered ?? this.isDelivered,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      orderNumber: orderNumber ?? this.orderNumber,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customer,
        orderItems,
        totalPrice,
        paymentType,
        isPaid,
        isDelivered,
        state,
        createdAt,
        updatedAt,
        orderNumber,
        version,
      ];
}

