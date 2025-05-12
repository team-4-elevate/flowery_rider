// features/Home_layout/data/model/home_order_response.dart
import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';

class HomeOrderResponse extends Equatable {
  final String message;
  final MetadataModel? metadata;
  final List<DriverOrderModel>? orders;

  const HomeOrderResponse({
    required this.message,
    this.metadata,
    this.orders,
  });

  factory HomeOrderResponse.fromJson(Map<String, dynamic> json) {
    return HomeOrderResponse(
      message: json['message'] as String? ?? '',
      metadata: json['metadata'] != null
          ? MetadataModel.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
      orders: json['orders'] != null
          ? (json['orders'] as List)
              .map((item) =>
                  DriverOrderModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'metadata': metadata?.toJson(),
      'orders': orders?.map((order) => order.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [message, metadata, orders];
}

class MetadataModel extends Equatable {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;

  const MetadataModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.limit,
  });

  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return MetadataModel(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems: json['totalItems'] as int? ?? 0,
      limit: json['limit'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'limit': limit,
    };
  }

  @override
  List<Object?> get props => [currentPage, totalPages, totalItems, limit];
}
