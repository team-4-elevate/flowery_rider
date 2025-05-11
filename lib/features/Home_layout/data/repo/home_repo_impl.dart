// features/Home_layout/data/repo/home_repo_impl.dart


import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/Home_layout/data/datasource/remote_data_source/home_remote_data_source.dart';
import 'package:flowery_rider/features/Home_layout/domain/entities/order_entity.dart';
import 'package:flowery_rider/features/Home_layout/domain/repo/home_repository.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  HomeRepositoryImpl(this._remoteDataSource, this._authLocalDataSource);

  @override
  Future<Either<ApiException, List<OrderEntity>>> getPendingOrders() async {
    try {
      final token = await _authLocalDataSource.getToken();
      
      if (token == null) {
        return Left(ApiException(message: 'Authentication token not found'));
      }
      
      final response = await _remoteDataSource.getPendingOrders();
      
      final orders = OrderEntity.fromModelList(response.right.orders);
      
      return Right(orders);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, bool>> acceptOrder(String orderId) async {
    try {
      final token = await _authLocalDataSource.getToken();
      
      if (token == null) {
        return Left(ApiException(message: 'Authentication token not found'));
      }
      
      final response = await _remoteDataSource.acceptOrder(orderId);
      
      return response;
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}
