import 'dart:async';
import 'dart:developer';
import 'package:flowery_rider/core/app_data/firebase/firebase_service_interface.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_states.dart';
import 'package:flowery_rider/features/order_details/domain/entities/order_status_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class HomeCubit extends Cubit<HomeStates> {
  final IDeliveryFirebaseService _firebase;
  StreamSubscription? _sub;
  bool _isListening = false;

  HomeCubit(this._firebase) : super(HomeStates(homeState: BaseInitialState())) {
    listenToOrders();
  }
  Future<void> rejectOrder(String orderId) async {
    await _firebase.updateOrderStatus(
        orderId: orderId, status: OrderStatusEnum.rejected);
  }

  listenToOrders() {
    if (_isListening) return;

    try {
      _isListening = true;
      emit(state.copyWith(homeState: BaseLoadingState()));
      final ordersStream = _firebase.fireMappedOrdersStream();
      if (ordersStream == null) {
        _isListening = false;
        emit(state.copyWith(
          homeState: BaseErrorState('Failed to get orders stream'),
        ));
        return;
      }

      _sub = ordersStream.listen(
        (orders) {
          emit(state.copyWith(
              firebaseOrders: orders,
              homeState: BaseSuccessState(data: orders)));
        },
        onError: (error) {
          _isListening = false;
          emit(state.copyWith(
            homeState: BaseErrorState(error.toString()),
          ));
        },
      );
    } catch (e) {
      _isListening = false;
      emit(state.copyWith(
        homeState: BaseErrorState(e.toString()),
      ));
    }
  }

  Future<void> changeOrderStatus({
    required String orderId,
    required OrderStatusEnum status,
  }) async {
    log(status.name);
    status == OrderStatusEnum.accepted
        ? await _firebase.acceptOrder(orderId: orderId)
        : await _firebase.updateOrderStatus(
            orderId: orderId,
            status: status,
          );
    emit(state.copyWith(currentStep: _setCurrentStep(status)));
  }

  @override
  Future<void> close() async {
    _isListening = false;
    await _sub?.cancel();
    return super.close();
  }

  _setCurrentStep(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.accepted:
        return 0;
      case OrderStatusEnum.pickedUp:
        return 1;
      case OrderStatusEnum.outForDelivery:
        return 2;
      case OrderStatusEnum.arrived:
        return 3;
      case OrderStatusEnum.delivered:
        return 4;
      default:
        return 0;
    }
  }

  void changeCurrentStep(int i) {
    emit(state.copyWith(currentStep: i));
  }
}
