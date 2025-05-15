import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/app_data/shared_models/orders/pickup_address.dart';
import 'package:flowery_rider/features/order_details/data/models/location_dm.dart';
import 'package:flowery_rider/features/order_details/domain/entities/order_status_enum.dart';
import 'package:flowery_rider/features/order_details/domain/entities/payment_type_enum.dart';
import 'customerDm.dart';
import 'order_item.dart';
import 'order_product.dart';

class DriverOrderModel extends Equatable {
  final String id;
  final Customer? customer;
  final List<OrderItem>? orderItems;
  final double totalPrice;
  final PaymentTypeEnum? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? createdAt;
  final String? updatedAt;
  final String? orderNumber;
  final int? version;
  final OrderStatusEnum? status;
  final PickupAddress? pickupAddress;

  const DriverOrderModel({
    required this.id,
    this.customer,
    this.orderItems,
    required this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.version,
    this.status,
    this.pickupAddress,
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'orderNumber': orderNumber,
      'pickupAddress': pickupAddress?.toJson(),
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
      totalPrice: (json['totalPrice'] as num).toDouble(),
      paymentType: (json['paymentType'] as String?)?.toPaymentEnum(),
      isPaid: json['isPaid'] as bool?,
      isDelivered: json['isDelivered'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      orderNumber: json['orderNumber'] as String?,
      pickupAddress: PickupAddress.fromJson(json),
      version: json['__v'] as int?,
    );
  }

  factory DriverOrderModel.fromFirebase(Map json, String orderId) {
    List<OrderItem> items = [];
    if (json['items'] != null) {
      final itemsData = json['items'] as List?;
      itemsData?.forEach(
        (e) {
          final OrderDmProduct product = OrderDmProduct(
            id: e['productId'] as String?,
            price: (e['price'] as num?)?.toDouble(),
          );
          items.add(OrderItem(
            id: e['productId'] as String?,
            orderProduct: product,
            price: (e['price'] as num?)?.toDouble(),
            quantity: e['quantity'] as int?,
            name: e['title'] as String?,
          ));
        },
      );
    }
    Customer? customer;
    if (json['user'] != null) {
      final itemsData = json['user'] as Map<dynamic, dynamic>;
      final userId = itemsData['_id'] as String;
      final email = itemsData['email'] as String?;
      final name = itemsData['name'] as String?;
      final phone = itemsData['phone'] as String?;
      final address = itemsData['address'] as String?;
      final location = itemsData['location'] != null
          ? LocationDM.fromJson(itemsData['location'] as Map)
          : null;
      customer = Customer(
          id: userId,
          firstName: name,
          address: address,
          location: location,
          phone: phone);
    }
    final pickupAddress = PickupAddress.fromJson(json);

    OrderStatusEnum status = json['state'] != null
        ? (json['state'] as String).toOrderStatusEnum()
        : OrderStatusEnum.pending;
    double totalPrice = (json['totalPrice']).toDouble();
    return DriverOrderModel(
      id: orderId,
      customer: customer,
      orderItems: items,
      totalPrice: totalPrice,
      isPaid: json['isPaid'] as bool?,
      isDelivered: json['isDelivered'] as bool?,
      createdAt: json['createdAt'] as String?,
      orderNumber: json.containsKey('_id') ? json['_id'] as String? : null,
      status: status,
      paymentType: (json['isPaid'] as bool? ?? false)
          ? PaymentTypeEnum.card
          : PaymentTypeEnum.cash,
      pickupAddress: pickupAddress,
      updatedAt: DateTime.now().toString(),
    );
  }

  DriverOrderModel copyWith({
    String? id,
    Customer? customer,
    List<OrderItem>? orderItems,
    double? totalPrice,
    PaymentTypeEnum? paymentType,
    bool? isPaid,
    bool? isDelivered,
    String? createdAt,
    String? updatedAt,
    String? orderNumber,
    int? version,
    OrderStatusEnum? status,
    PickupAddress? pickupAddress,
  }) {
    return DriverOrderModel(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      orderItems: orderItems ?? this.orderItems,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentType: paymentType ?? this.paymentType,
      isPaid: isPaid ?? this.isPaid,
      isDelivered: isDelivered ?? this.isDelivered,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      orderNumber: orderNumber ?? this.orderNumber,
      version: version ?? this.version,
      status: status ?? this.status,
      pickupAddress: pickupAddress ?? this.pickupAddress,
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
        createdAt,
        updatedAt,
        orderNumber,
        version,
        pickupAddress
      ];
}
