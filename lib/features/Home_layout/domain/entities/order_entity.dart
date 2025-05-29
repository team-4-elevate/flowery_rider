import 'package:flowery_rider/core/app_data/shared_models/orders/full_order_model.dart';

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
      state.toLowerCase() == 'pending' ||
      state.toLowerCase() == 'inprogress' ||
      state.toLowerCase() == 'completed';

  factory OrderEntity.fromModel(FullOrderModel fullOrder) {
    final driverOrder = fullOrder.order;

    final name = driverOrder?.customer?.firstName ?? '';

    final storeAddress =
        fullOrder.store?.address ?? '20th st, Sheikh Zayed, Giza';

    final userAddress = storeAddress.contains(',')
        ? storeAddress
        : '20th st,Sheikh Zayed, Giza';

    double price = 0.0;
    if (driverOrder?.totalPrice != null) {
      price = driverOrder!.totalPrice!;
    }

    return OrderEntity(
      id: fullOrder.id ?? '',
      orderId: driverOrder?.id ?? '',
      storeAddress: fullOrder.store?.address ?? 'Store address unavailable',
      userName: name.isEmpty ? 'Unknown Customer' : name,
      userAddress: userAddress,
      price: price,
      state: driverOrder?.status?.name ?? '',
    );
  }

  static List<OrderEntity> fromModelList(List<FullOrderModel>? orders) {
    if (orders == null) return [];
    return orders.map((order) => OrderEntity.fromModel(order)).toList();
  }
}
