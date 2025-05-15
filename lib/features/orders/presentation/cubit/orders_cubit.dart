// features/orders/presentation/cubit/orders_cubit.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flowery_rider/core/app_data/firebase/firebase_service_interface.dart';
import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/features/order_details/domain/entities/order_status_enum.dart';
import 'package:flowery_rider/features/orders/presentation/cubit/orders_states.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrdersCubit extends Cubit<OrdersStates> {
  final IDeliveryFirebaseService _firebase;
  final DatabaseReference _ordersRef = FirebaseDatabase.instance.ref('orders');
  StreamSubscription? _ordersSub;

  OrdersCubit(this._firebase)
      : super(OrdersStates(ordersState: BaseInitialState())) {
    fetchOrders();
  }

  void fetchOrders() {
    _ordersSub?.cancel();
    emit(OrdersStates(ordersState: BaseLoadingState()));

    _ordersRef.get().then((snapshot) {
      if (snapshot.value != null) {
        try {
          _processOrdersData(snapshot.value);
        } catch (_) {}
      }
    },
        onError: (error) =>
            emit(OrdersStates(ordersState: BaseErrorState(error.toString()))));

    final ordersStream = _firebase.fireMappedOrdersStream();
    if (ordersStream == null) return;

    _ordersSub = ordersStream.listen((_) {
      _ordersRef.get().then((snapshot) {
        if (snapshot.value != null) {
          try {
            _processOrdersData(snapshot.value);
          } catch (_) {}
        }
      });
    },
        onError: (error) =>
            emit(OrdersStates(ordersState: BaseErrorState(error.toString()))));
  }

  void _processOrdersData(dynamic snapshot) {
    final ordersData =
        Map<String, dynamic>.from(snapshot as Map<Object?, Object?>);
    final allOrders = <DriverOrderModel>[];

    ordersData.forEach((orderId, orderData) {
      if (orderData is Map<dynamic, dynamic>) {
        try {
          allOrders.add(DriverOrderModel.fromFirebase(orderData, orderId));
        } catch (_) {}
      }
    });

    final completed = allOrders
        .where((order) =>
            order.status == OrderStatusEnum.delivered ||
            order.status == OrderStatusEnum.accepted)
        .toList();

    final cancelled = allOrders
        .where((order) => order.status == OrderStatusEnum.rejected)
        .toList();

    emit(OrdersStates(
      ordersState: BaseSuccessState(),
      completedOrders: completed,
      cancelledOrders: cancelled,
    ));
  }

  @override
  Future<void> close() async {
    await _ordersSub?.cancel();
    return super.close();
  }
}
