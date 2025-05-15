import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:equatable/equatable.dart';

class OrdersStates extends Equatable {
  final BaseState ordersState;
  final List<DriverOrderModel> completedOrders;
  final List<DriverOrderModel> cancelledOrders;

  const OrdersStates({
    required this.ordersState,
    this.completedOrders = const [],
    this.cancelledOrders = const [],
  });

  @override
  List<Object?> get props => [ordersState, completedOrders, cancelledOrders];

  OrdersStates copyWith({
    BaseState? ordersState,
    List<DriverOrderModel>? completedOrders,
    List<DriverOrderModel>? cancelledOrders,
  }) =>
      OrdersStates(
        ordersState: ordersState ?? this.ordersState,
        completedOrders: completedOrders ?? this.completedOrders,
        cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      );
}
