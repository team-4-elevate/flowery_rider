// features/Home_layout/presentation/cubit/home_states.dart

import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';
import 'package:flowery_rider/core/base/base_state.dart';

class HomeStates extends Equatable {
  final BaseState homeState;
  final int currentStep;
  final List<DriverOrderModel>? firebaseOrders;

  const HomeStates({
    required this.homeState,
    this.firebaseOrders,
    this.currentStep = 0,
  });

  HomeStates copyWith(
      {BaseState? homeState,
      List<DriverOrderModel>? firebaseOrders,
      int? currentStep}) {
    return HomeStates(
        homeState: homeState ?? this.homeState,
        firebaseOrders: firebaseOrders ?? this.firebaseOrders,
        currentStep: currentStep ?? this.currentStep);
  }

  @override
  List<Object?> get props => [homeState, firebaseOrders, currentStep];
}
