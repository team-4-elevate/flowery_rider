// features/Home_layout/data/repo/home_repo_impl.dart

import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/Home_layout/data/datasource/remote_data_source/home_remote_data_source.dart';
import 'package:flowery_rider/features/Home_layout/domain/entities/order_entity.dart';
import 'package:flowery_rider/features/Home_layout/domain/repo/home_repository.dart';
import 'package:flowery_rider/features/auth/data/datasource/local_data_source/auth_local_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final AuthLocalDataSourceContract _authLocalDataSource;

  HomeRepositoryImpl(this._remoteDataSource, this._authLocalDataSource);

  @override
  Future<Either<ApiException, List<OrderEntity>>> getPendingOrders() async {
    try {
      final token = await _authLocalDataSource.getToken();

      if (token == null) {
        return Left(ApiException(message: 'Authentication token not found'));
      }

      final response = await _remoteDataSource.getPendingOrders();
      
      // Check if we got any orders from the API
      if (response.right.orders != null && response.right.orders!.isNotEmpty) {
        // Debug the first order to see all relevant fields
        final firstOrder = response.right.orders!.first;
        final nestedOrder = firstOrder.order;
        print('🔍 First order from API: id=${firstOrder.id}');
        print('🔍 - state: ${nestedOrder?.state}');
        print('🔍 - totalPrice: ${nestedOrder?.totalPrice}');
        print('🔍 - user details: firstName=${nestedOrder?.user?.firstName}, lastName=${nestedOrder?.user?.lastName}');
      }

      // Override with a test order if needed to verify UI
      final orders = OrderEntity.fromModelList(response.right.orders);
      
      // Debug the final entity mapping
      if (orders.isNotEmpty) {
        print('🔍 First mapped entity: id=${orders.first.id}, state=${orders.first.state}');
      }

      final Map<String, OrderEntity> uniqueOrdersMap = {};
      for (final order in orders) {
        uniqueOrdersMap[order.id] = order;
      }

      final uniqueOrders = uniqueOrdersMap.values.toList();

      return Right(uniqueOrders);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }


}
