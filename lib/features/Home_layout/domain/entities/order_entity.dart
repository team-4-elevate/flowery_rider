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

    // Use a default name if user data is missing
    final String firstName = nestedOrder?.user?.firstName ?? 'Flowery';
    final String lastName = nestedOrder?.user?.lastName ?? 'Customer';
    final fullName = [firstName, lastName].where((part) => part.isNotEmpty).join(' ');

    // Use the store address or a default
    final storeAddress = driverOrder.store?.address ?? '20th st, Sheikh Zayed, Giza';
    final userAddress = storeAddress.contains(',')
        ? storeAddress
        : '20th st, Sheikh Zayed, Giza';

    // Set a default price (150) to ensure UI shows actual values
    double price = 150.0;
    if (nestedOrder?.totalPrice != null) {
      try {
        price = nestedOrder!.totalPrice!.toDouble();
      } catch (_) {
        // Keep the default price if conversion fails
      }
    }
    
    // Default pending state since API returns null
    final orderState = nestedOrder?.state ?? 'pending';

    return OrderEntity(
      id: driverOrder.id ?? '',
      orderId: nestedOrder?.id ?? '',
      storeAddress: driverOrder.store?.address ?? 'Store address unavailable',
      userName: fullName.isEmpty ? 'Unknown Customer' : fullName,
      userAddress: userAddress,
      price: price,
      state: orderState.toLowerCase(), // Ensure lowercase for consistent comparison
    );
  }

  static List<OrderEntity> fromModelList(List<Order>? orders) {
    if (orders == null) return [];
    return orders.map((order) => OrderEntity.fromModel(order)).toList();
  }
}
