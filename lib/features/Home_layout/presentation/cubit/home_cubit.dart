// features/Home_layout/presentation/cubit/home_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/features/Home_layout/domain/entities/order_entity.dart';
import 'package:flowery_rider/features/Home_layout/domain/repo/home_repository.dart';
import 'package:flowery_rider/features/Home_layout/domain/use_case/home_usecase.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_states.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends Cubit<HomeStates> {
  final HomeUseCase _homeUseCase;
  final HomeRepository _homeRepository;
  final Set<String> _rejectedOrderIds = {};

  HomeCubit(this._homeUseCase, this._homeRepository)
      : super(HomeStates(homeState: BaseInitialState()));

  List<OrderEntity> get visibleOrders {
    final pendingOrders =
        state.orders.where((order) => order.isPending).toList();
    final notRejectedOrders = pendingOrders
        .where((order) => !_rejectedOrderIds.contains(order.id))
        .toList();
    return notRejectedOrders;
  }

  void rejectOrder(String orderId) {
    _rejectedOrderIds.add(orderId);
    emit(HomeStates(
      homeState: BaseSuccessState<List<OrderEntity>>(data: state.orders),
      orders: state.orders,
    ));
  }

  Future<void> getPendingOrders() async {
    emit(state.copyWith(homeState: BaseLoadingState()));
    _rejectedOrderIds.clear();

    final result = await _homeUseCase();

    if (result.isLeft) {
      final error = result.left;
      emit(state.copyWith(homeState: BaseErrorState(error.message)));
    } else {
      final orders = result.right;
      emit(state.copyWith(
        homeState: BaseSuccessState<List<OrderEntity>>(data: orders),
        orders: orders,
      ));
    }
  }
}
