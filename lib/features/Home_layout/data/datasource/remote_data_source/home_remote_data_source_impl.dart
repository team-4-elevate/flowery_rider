// features/Home_layout/data/datasource/remote_data_source/home_remote_data_source_impl.dart

import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/core/logger/app_logger.dart';
import 'package:flowery_rider/features/Home_layout/data/datasource/remote_data_source/home_remote_data_source.dart';
import 'package:flowery_rider/features/Home_layout/data/model/home_order_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<ApiException, HomeOrderResponse>> getPendingOrders() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.pendingOrders,
        requiresToken: true,
      );

      final ordersResponse = HomeOrderResponse.fromJson(response);
      return Right(ordersResponse);
    } catch (e) {
      Log.e('Error fetching pending orders: $e');
      return Left(ApiException(message: 'Failed to fetch pending orders: $e'));
    }
  }

}
