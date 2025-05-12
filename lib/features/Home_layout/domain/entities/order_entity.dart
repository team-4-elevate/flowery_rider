// features/Home_layout/domain/entities/order_entity.dart

import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';
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

  factory OrderEntity.fromModel(dynamic orderData) {
    if (orderData is DriverOrderModel) {
      final order = orderData;
      final firstName = order.customer?.firstName ?? '';
      final lastName = order.customer?.lastName ?? '';
      final fullName =
          [firstName, lastName].where((part) => part.isNotEmpty).join(' ');

      String storeAddress = '20th st, Sheikh Zayed, Giza';

      if (orderData.toJson().containsKey('store') &&
          orderData.toJson()['store'] != null) {
        final storeData = orderData.toJson()['store'];
        if (storeData is Map && storeData.containsKey('address')) {
          storeAddress = storeData['address'] ?? storeAddress;
        }
      }

      final userAddress = storeAddress.contains(',')
          ? storeAddress
          : '20th st,Sheikh Zayed, Giza';

      double price = 0.0;
      if (order.totalPrice != null) {
        price = order.totalPrice!;
      }

      return OrderEntity(
        id: order.id ?? '',
        orderId: order.orderNumber ?? '',
        storeAddress: storeAddress,
        userName: fullName.isEmpty ? 'Unknown Customer' : fullName,
        userAddress: userAddress,
        price: price,
        state: order.state ?? '',
      );
    } else if (orderData is FullOrderModel) {
      final fullOrder = orderData;
      final driverOrder = fullOrder.order;

      final firstName = driverOrder?.customer?.firstName ?? '';
      final lastName = driverOrder?.customer?.lastName ?? '';
      final fullName =
          [firstName, lastName].where((part) => part.isNotEmpty).join(' ');

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
        storeAddress: storeAddress,
        userName: fullName.isEmpty ? 'Unknown Customer' : fullName,
        userAddress: userAddress,
        price: price,
        state: driverOrder?.state ?? '',
      );
    }

    return OrderEntity(
      id: '',
      orderId: '',
      storeAddress: 'Unknown Address',
      userName: 'Unknown Customer',
      userAddress: 'Unknown Address',
      price: 0.0,
      state: '',
    );
  }

  static List<OrderEntity> fromModelList(List<dynamic>? orders) {
    if (orders == null) return [];
    return orders.map((order) => OrderEntity.fromModel(order)).toList();
  }
}
