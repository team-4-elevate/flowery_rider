// features/Home_layout/domain/entities/order_entity.dart

import 'package:flowery_rider/features/Home_layout/data/model/orders_pending/order.dart';

class OrderEntity {
  final String id;
  final String orderId;
  final String storeAddress;
  final String userName;
  final String userAddress;
  final double price;
  final String state;

  OrderEntity({
    required this.id,
    required this.orderId,
    required this.storeAddress,
    required this.userName,
    required this.userAddress,
    required this.price,
    required this.state,
  });

  String get formattedPrice => 'EGP ${price.toStringAsFixed(0)}';
  bool get isPending =>
      state.toLowerCase() == 'pending' || state.toLowerCase() == 'inprogress';

  factory OrderEntity.fromModel(Order driverOrder) {
    final nestedOrder = driverOrder.order;

    final firstName = nestedOrder?.user?.firstName ?? '';
    final lastName = nestedOrder?.user?.lastName ?? '';
    final fullName =
        [firstName, lastName].where((part) => part.isNotEmpty).join(' ');

    final storeAddress =
        driverOrder.store?.address ?? '20th st, Sheikh Zayed, Giza';

    final userAddress = storeAddress.contains(',')
        ? storeAddress
        : '20th st,Sheikh Zayed, Giza';

    double price = 0.0;
    if (nestedOrder?.totalPrice != null) {
      price = nestedOrder!.totalPrice!.toDouble();
    }

    return OrderEntity(
      id: driverOrder.id ?? '',
      orderId: nestedOrder?.id ?? '',
      storeAddress: driverOrder.store?.address ?? 'Store address unavailable',
      userName: fullName.isEmpty ? 'Unknown Customer' : fullName,
      userAddress: userAddress,
      price: price,
      state: nestedOrder?.state ?? '',
    );
  }

  static List<OrderEntity> fromModelList(List<Order>? orders) {
    if (orders == null) return [];
    return orders.map((order) => OrderEntity.fromModel(order)).toList();
  }
}
