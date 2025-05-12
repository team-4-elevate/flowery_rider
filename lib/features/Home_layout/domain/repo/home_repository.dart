// features/Home_layout/domain/repo/home_repository.dart

import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/Home_layout/domain/entities/order_entity.dart';

abstract class HomeRepository {
  Future<Either<ApiException, List<OrderEntity>>> getPendingOrders();
}
