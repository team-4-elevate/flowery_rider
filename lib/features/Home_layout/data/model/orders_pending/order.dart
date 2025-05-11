import 'order_item.dart';
import 'store.dart';
import 'user.dart';

class Order {
  String? id;
  String? driver;
  NestedOrder? order;
  Store? store;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Order({
    this.id,
    this.driver,
    this.order,
    this.store,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['_id'] as String?,
        driver: json['driver'] as String?,
        order: json['order'] == null
            ? null
            : NestedOrder.fromJson(json['order'] as Map<String, dynamic>),
        store: json['store'] == null
            ? null
            : Store.fromJson(json['store'] as Map<String, dynamic>),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'driver': driver,
        'order': order?.toJson(),
        'store': store?.toJson(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };
}

// Nested order structure as seen in the API response
class NestedOrder {
  String? id;
  User? user;
  List<OrderItem>? orderItems;
  int? totalPrice;
  String? paymentType;
  bool? isPaid;
  bool? isDelivered;
  String? state;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderNumber;
  int? v;

  NestedOrder({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
  });

  factory NestedOrder.fromJson(Map<String, dynamic> json) => NestedOrder(
        id: json['_id'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        orderItems: (json['orderItems'] as List<dynamic>?)
            ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalPrice: json['totalPrice'] as int?,
        paymentType: json['paymentType'] as String?,
        isPaid: json['isPaid'] as bool?,
        isDelivered: json['isDelivered'] as bool?,
        state: json['state'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        orderNumber: json['orderNumber'] as String?,
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user?.toJson(),
        'orderItems': orderItems?.map((e) => e.toJson()).toList(),
        'totalPrice': totalPrice,
        'paymentType': paymentType,
        'isPaid': isPaid,
        'isDelivered': isDelivered,
        'state': state,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'orderNumber': orderNumber,
        '__v': v,
      };
}
