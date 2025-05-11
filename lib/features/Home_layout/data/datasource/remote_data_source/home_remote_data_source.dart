// features/Home_layout/data/datasource/remote_data_source/home_remote_data_source.dart

import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/Home_layout/data/model/orders_pending/orders_pending.dart';

abstract class HomeRemoteDataSource {
  Future<Either<ApiException, OrdersPending>> getPendingOrders();
  
  Future<Either<ApiException, bool>> acceptOrder(String orderId);
  
}
