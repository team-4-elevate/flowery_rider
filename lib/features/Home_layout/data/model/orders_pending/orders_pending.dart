import 'metadata.dart';
import 'order.dart';

class OrdersPending {
  String? message;
  Metadata? metadata;
  List<Order>? orders;

  OrdersPending({this.message, this.metadata, this.orders});

  factory OrdersPending.fromJson(Map<String, dynamic> json) => OrdersPending(
        message: json['message'] as String?,
        metadata: json['metadata'] == null
            ? null
            : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
        orders: (json['orders'] as List<dynamic>?)
            ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'metadata': metadata?.toJson(),
        'orders': orders?.map((e) => e.toJson()).toList(),
      };
}
