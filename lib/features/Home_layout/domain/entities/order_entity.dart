// features/Home_layout/domain/entities/order_entity.dart

import 'package:flowery_rider/features/Home_layout/data/model/orders_pending/order.dart';

class OrderEntity {
  final String id;
  final String storeAddress;
  final String userName;
  final String userAddress;
  final double price;
  final String state;

  OrderEntity({
    required this.id,
    required this.storeAddress,
    required this.userName,
    required this.userAddress,
    required this.price,
    required this.state,
  });

  String get formattedPrice => 'EGP ${price.toStringAsFixed(0)}';
  bool get isPending => state.toLowerCase() == 'pending';

  factory OrderEntity.fromModel(Order order) {
    final firstName = order.user?.firstName ?? '';
    final lastName = order.user?.lastName ?? '';
    final fullName =
        [firstName, lastName].where((part) => part.isNotEmpty).join(' ');

    final street = order.shippingAddress?.street ?? '';
    final city = order.shippingAddress?.city ?? '';
    final fullAddress =
        [street, city].where((part) => part.isNotEmpty).join(', ');

    return OrderEntity(
      id: order.id ?? '',
      storeAddress: order.store?.address ?? '',
      userName: fullName,
      userAddress: fullAddress,
      price: (order.totalPrice ?? 0).toDouble(),
      state: order.state ?? '',
    );
  }

  static List<OrderEntity> fromModelList(List<Order>? orders) {
    if (orders == null) return [];
    return orders.map((order) => OrderEntity.fromModel(order)).toList();
  }
}
