import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flowery_rider/core/app_data/firebase/firebase_service_interface.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_states.dart';
import 'package:flowery_rider/features/order_details/domain/entities/order_status_enum.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends Cubit<HomeStates> {
  final IDeliveryFirebaseService _firebase;
  StreamSubscription? _sub;

  HomeCubit(this._firebase) : super(HomeStates(homeState: BaseInitialState())) {
    listenToOrders();
  }
  Future<void> rejectOrder(String orderId) async {
    await _firebase.updateOrderStatus(
        orderId: orderId, status: OrderStatusEnum.rejected);
  }

  listenToOrders() {
    try {
      emit(state.copyWith(homeState: BaseLoadingState()));
      final ordersStream = _firebase.fireMappedOrdersStream();
      if (ordersStream == null) {
        emit(state.copyWith(
          homeState: BaseErrorState('Failed to get orders stream'),
        ));
        return;
      }
      _sub = ordersStream.listen(
        (orders) {
          if ((orders.isNotEmpty && state.firebaseOrders == null) ||
              (orders.isNotEmpty &&
                  orders.length != state.firebaseOrders?.length)) {
            emit(state.copyWith(
                firebaseOrders: orders, homeState: BaseInitialState()));
          }
        },
        onError: (error) {
          emit(state.copyWith(
            homeState: BaseErrorState(error.toString()),
          ));
        },
      );
    } catch (e) {
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
