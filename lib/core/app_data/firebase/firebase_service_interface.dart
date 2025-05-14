import '../../../../core/app_data/shared_models/orders/driver.dart';
import '../../../features/order_details/domain/entities/order_status_enum.dart';
import '../shared_models/orders/driver_order_model.dart';
abstract class IDeliveryFirebaseService {
  Stream<List<DriverOrderModel>>? fireMappedOrdersStream();

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatusEnum status,
  });
  Future<void> acceptOrder({
    required String orderId,
  });
  Future<void> dispose();
}