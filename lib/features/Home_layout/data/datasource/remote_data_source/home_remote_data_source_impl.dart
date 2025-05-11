// features/Home_layout/data/datasource/remote_data_source/home_remote_data_source_impl.dart

import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/core/logger/app_logger.dart';
import 'package:flowery_rider/features/Home_layout/data/datasource/remote_data_source/home_remote_data_source.dart';
import 'package:flowery_rider/features/Home_layout/data/model/orders_pending/orders_pending.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<ApiException, OrdersPending>> getPendingOrders() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.homeEndPoint,
        requiresToken: true,
      );

      // Log the full response to examine its structure
      print('🔍 API RESPONSE: ${response.toString().substring(0, 500)}...');
      
      // Check if we have user information anywhere else in the response
      if (response.containsKey('orders') && response['orders'] is List && (response['orders'] as List).isNotEmpty) {
        final firstOrder = response['orders'][0];
        print('🔍 First order raw: ${firstOrder.toString().substring(0, 500)}...');
        
        // Check for user info in different locations
        if (firstOrder.containsKey('user')) {
          print('🔍 User info directly in order: ${firstOrder['user']}');
        }
        
        if (firstOrder.containsKey('order') && firstOrder['order'] != null) {
          print('🔍 Nested order: ${firstOrder['order'].toString().substring(0, 250)}...');
          if (firstOrder['order'].containsKey('user')) {
            print('🔍 User in nested order: ${firstOrder['order']['user']}');
          }
        }
      }

      final ordersResponse = OrdersPending.fromJson(response);
      return Right(ordersResponse);
    } catch (e) {
      Log.e('Error fetching pending orders: $e');
      return Left(ApiException(message: 'Failed to fetch pending orders: $e'));
    }
  }

}
