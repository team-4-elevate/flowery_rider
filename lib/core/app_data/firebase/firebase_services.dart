import 'package:flowery_rider/core/app_data/shared_models/orders/full_order_model.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_database/firebase_database.dart';

@lazySingleton
class FirebaseServices {
  FirebaseServices();

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference get _ordersRef => _database.ref('orders');

  Future<void> sendOrderDataToFireBase(FullOrderModel order) async {
    await _ordersRef.set(order.toJson());
  }
}
