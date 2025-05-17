// features/orders/presentation/cubit/orders_cubit.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flowery_rider/core/app_data/firebase/firebase_service_interface.dart';
import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:flowery_rider/features/order_details/domain/entities/order_status_enum.dart';
import 'package:flowery_rider/features/orders/presentation/cubit/orders_states.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrdersCubit extends Cubit<OrdersStates> {
  final IDeliveryFirebaseService _firebase;
  final DatabaseReference _ordersRef = FirebaseDatabase.instance.ref('orders');
  late final AuthLocalDataSource _authLocalDataSource;
  StreamSubscription? _ordersSub;
  String? _currentDriverId;

  OrdersCubit(this._firebase)
      : super(OrdersStates(ordersState: BaseInitialState())) {
    _authLocalDataSource = GetIt.instance<AuthLocalDataSource>();
    _initialize();
  }
  
  Future<void> _initialize() async {
    await _getCurrentDriverId();
    fetchOrders();
  }

  Future<void> _getCurrentDriverId() async {
    String? storedDriverId = await _authLocalDataSource.getDriverId();
    
    if (storedDriverId != null && storedDriverId.isNotEmpty) {
      _currentDriverId = storedDriverId;
      print('Retrieved driver ID from storage: $_currentDriverId');
      return;
    }
    
    final User? currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser != null) {
      _currentDriverId = currentUser.uid;
      print('Current Driver ID from auth: $_currentDriverId');
      
      if (_currentDriverId != null && _currentDriverId!.isNotEmpty) {
        await _authLocalDataSource.cacheDriverId(_currentDriverId!);
        print('Saved driver ID to storage: $_currentDriverId');
      }
    } else {
      _currentDriverId = '30001004305454';
      print('Using test driver ID: $_currentDriverId (DEVELOPMENT ONLY)');
      
      await _authLocalDataSource.cacheDriverId(_currentDriverId!);
    }
  }

  void fetchOrders() {
    _ordersSub?.cancel();
    emit(OrdersStates(ordersState: BaseLoadingState()));

    final Query ordersQuery = _ordersRef;

    ordersQuery.get().then((snapshot) {
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
      ordersQuery.get().then((snapshot) {
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
    
    print('Processing orders with current driver ID: $_currentDriverId');
    print('Total orders in Firebase: ${ordersData.length}');
    int filteredCount = 0;

    ordersData.forEach((orderId, orderData) {
      if (orderData is Map<dynamic, dynamic>) {
        try {
          if (orderData['driver'] != null && orderData['driver'] is Map) {
            final driverData = orderData['driver'] as Map;
            final driverId = driverData['id'] as String?;
            
            print('Order $orderId - Driver ID in order: $driverId');

            if (_currentDriverId == null || driverId == _currentDriverId) {
              allOrders.add(DriverOrderModel.fromFirebase(orderData, orderId));
              filteredCount++;
            }
          } else {
            print('Order $orderId - No driver assigned');
            allOrders.add(DriverOrderModel.fromFirebase(orderData, orderId));
            filteredCount++;
          }
        } catch (_) {}
      }
    });

    print('Orders after filtering: $filteredCount');
    
    final completed = allOrders
        .where((order) =>
            order.status == OrderStatusEnum.delivered ||
            order.status == OrderStatusEnum.accepted)
        .toList();

    final cancelled = allOrders
        .where((order) => order.status == OrderStatusEnum.rejected)
        .toList();
        
    print('Completed orders: ${completed.length}, Cancelled orders: ${cancelled.length}');

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
