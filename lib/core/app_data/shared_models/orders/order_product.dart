import 'package:equatable/equatable.dart';

class OrderDmProduct extends Equatable {
  final String? id;
  final double? price;

  const OrderDmProduct({
    required this.id,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'price': price,
    };
  }

  factory OrderDmProduct.fromJson(Map<String, dynamic> json) {
    return OrderDmProduct(
      id: json['_id'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [id, price];
}
