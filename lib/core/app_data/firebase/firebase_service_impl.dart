import 'dart:async';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flowery_rider/core/app_data/firebase/firebase_service_interface.dart';
import 'package:flowery_rider/core/app_data/local_storage/local_storage_client.dart';
import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';
import 'package:flowery_rider/features/order_details/domain/entities/order_status_enum.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

@LazySingleton(as: IDeliveryFirebaseService)
class FirebaseDriverServiceImpl implements IDeliveryFirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final Location _location = Location();
  final LocalStorageClient _localStorageClient;
  final StreamController ordersStream = StreamController.broadcast();
  StreamSubscription<DatabaseEvent>? _ordersSub;

  FirebaseDriverServiceImpl(this._localStorageClient) {
    _startListeningToOrders(
      onData: (allOrders) {
        ordersStream.add(allOrders);
      },
      onError: (error) {
        log('error in firebase:" ${error.toString()}');
      },
    );
    fireMappedOrdersStream();
  }

  DatabaseReference get _ordersRef => _database.ref('orders');

  StreamSubscription<LocationData>? _locationSubscription;

  @override
  Stream<List<DriverOrderModel>>? fireMappedOrdersStream() {
    return ordersStream.stream.map((ordersMap) {
      List<DriverOrderModel> ordersList = [];
      if (ordersMap is Map<dynamic, dynamic>) {
        ordersMap.forEach((orderId, orderData) {
          // try {
            if (orderData is Map<dynamic, dynamic>) {
              DriverOrderModel order = DriverOrderModel.fromFirebase(
                orderData,
                orderId.toString(),
              );
              ordersList.add(order);
            }
          // } catch (e) {
          //   log(e.toString());
          // }
        });
      }
      return ordersList
          .where((e) => e.status != OrderStatusEnum.rejected)
          .toList();
    });
  }

  void _startListeningToOrders({
    required void Function(Map<String, dynamic> allOrders) onData,
    void Function(Object error)? onError,
  }) {
    _ordersSub = _ordersRef.onValue.listen(
      (DatabaseEvent event) {
        final snapshot = event.snapshot;
        if (snapshot.value == null) {
          onData(<String, dynamic>{});
          return;
        }
        final raw = Map<String, dynamic>.from(
          snapshot.value as Map<Object?, Object?>,
        );

        onData(raw);
      },
      onError: onError,
    );
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatusEnum status,
  }) async {
    try {
      log(status.name);
      log('1');
      await _ordersRef.child(orderId).update({
        'state': status.name,
      });
      log(status.name);
      log('1');
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> _startLocationTracking(String orderId, String driverId) async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permissions are denied');
      }
    }

    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 10000,
    );

    _locationSubscription = _location.onLocationChanged.listen(
      (LocationData currentLocation) async {
        await _ordersRef.child(orderId).child('location').update({
          'lat': currentLocation.latitude,
          'lng': currentLocation.longitude,
        });
      },
    );
  }

  Future<void> _stopLocationTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  Future<void> acceptOrder({
    required String orderId,
  }) async {
    await updateOrderStatus(
      orderId: orderId,
      status: OrderStatusEnum.accepted,
    );
    final driverData = await _localStorageClient.getDriverData();
    if (driverData == null) {
      log('error getting driver data');
      return;
    }
    log('www');
    await _startLocationTracking(orderId, 'driverData.id');
    await updateOrderStatus(orderId: orderId, status: OrderStatusEnum.accepted);

    await _ordersRef.child(orderId).child('driver').update(driverData.toJson());
  }

  @override
  Future<void> dispose() async {
    await _stopLocationTracking();
    _ordersSub?.cancel();
  }
}
