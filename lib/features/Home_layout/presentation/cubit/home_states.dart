// features/Home_layout/presentation/cubit/home_states.dart

import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/features/Home_layout/domain/entities/order_entity.dart';

class HomeStates {
  final BaseState homeState;
  final List<OrderEntity> orders;

  const HomeStates({
    required this.homeState,
    this.orders = const [],
  });

  HomeStates copyWith({
    BaseState? homeState,
    List<OrderEntity>? orders,
  }) {
    return HomeStates(
      homeState: homeState ?? this.homeState,
      orders: orders ?? this.orders,
    );
  }
}
