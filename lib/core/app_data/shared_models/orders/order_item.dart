import 'package:equatable/equatable.dart';
import 'order_product.dart';

class OrderItem extends Equatable {
  final OrderDmProduct? orderProduct;
  final double? price;
  final int? quantity;
  final String? id;

  const OrderItem({
    required this.orderProduct,
    required this.price,
    required this.quantity,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'product': orderProduct?.toJson(),
      'price': price,
      'quantity': quantity,
      '_id': id,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderProduct: json['product'] != null
          ? OrderDmProduct.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      price: (json['price'] as num?)?.toDouble(),
      quantity: json['quantity'] as int?,
      id: json['_id'] as String?,
    );
  }

  @override
  List<Object?> get props => [orderProduct, price, quantity, id];
}
