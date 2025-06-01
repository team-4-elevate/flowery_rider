// features/orders/presentation/pages/orders_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_cubit.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_states.dart';
import 'package:flowery_rider/features/order_details/domain/entities/order_status_enum.dart';
import 'package:flowery_rider/features/orders/presentation/widgets/order_card.dart';
import 'package:flowery_rider/features/orders/presentation/widgets/summary_card.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersScreen extends StatelessWidget {
  final String? driverId;

  const OrdersScreen({super.key, required this.driverId});

  List<DriverOrderModel> _filterOrdersByDriverId(
      List<DriverOrderModel>? orders) {
    if (orders == null) return [];
    return orders;
  }

  List<DriverOrderModel> _getCompletedOrders(List<DriverOrderModel> orders) {
    return orders
        .where((order) =>
            order.status == OrderStatusEnum.delivered ||
            order.status == OrderStatusEnum.accepted)
        .toList();
  }

  List<DriverOrderModel> _getCancelledOrders(List<DriverOrderModel> orders) {
    return orders
        .where((order) => order.status == OrderStatusEnum.rejected)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final filteredOrders = _filterOrdersByDriverId(state.firebaseOrders);
        final completedOrders = _getCompletedOrders(filteredOrders);
        final cancelledOrders = _getCancelledOrders(filteredOrders);

        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            appBar: AppBar(
              title: Text(LocaleKeys.profile_orders_title.tr()),
              automaticallyImplyLeading: false,
              surfaceTintColor: Colors.transparent,
            ),
            body: state.homeState is BaseErrorState
                ? _buildErrorState(context)
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //-------------------------------------------------summary cards
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                count: cancelledOrders.length,
                                status:
                                    LocaleKeys.profile_orders_cancelled.tr(),
                                statusIcon: Icons.cancel_outlined,
                                statusColor: AppColors.error,
                                backgroundColor: AppColors.lightPink,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: SummaryCard(
                                count: completedOrders.length,
                                status:
                                    LocaleKeys.profile_orders_completed.tr(),
                                statusIcon: Icons.check_circle_outline,
                                statusColor: AppColors.success,
                                backgroundColor:
                                    AppColors.success.withAlpha(20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        //-------------------------------------------------recent orders
                        Text(
                          LocaleKeys.profile_orders_recent_orders.tr(),
                          style: getBoldStyle(
                              color: AppColors.black, fontSize: 16.sp),
                        ),
                        SizedBox(height: 16.h),
                        _buildOrdersList(
                            state, completedOrders, cancelledOrders),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

//-----------------------------------------------------------------Error State
  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.profile_orders_failed_to_load.tr(),
            style: getMediumStyle(color: AppColors.error, fontSize: 16.sp),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () => context.read<HomeCubit>().listenToOrders(),
            child: Text(LocaleKeys.profile_orders_retry.tr(),
                style:
                    getMediumStyle(color: AppColors.primary, fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------- loading indicator during initial data fetch
  Widget _buildOrdersList(
      HomeStates state,
      List<DriverOrderModel> completedOrders,
      List<DriverOrderModel> cancelledOrders) {
    if (state.homeState is BaseLoadingState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.profile_orders_loading.tr(),
              style: getMediumStyle(color: AppColors.grey, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    // If no orders found after filtering
    if (completedOrders.isEmpty && cancelledOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48.sp, color: AppColors.grey),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.profile_orders_no_orders_found.tr(),
              style: getMediumStyle(color: AppColors.grey, fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              LocaleKeys.profile_orders_no_orders_message.tr(),
              style: getRegularStyle(color: AppColors.grey, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Completed orders
        ...completedOrders.map((order) => OrderCard(
              orderNumber: order.id,
              status: LocaleKeys.profile_orders_completed.tr(),
              isCompleted: true,
              orderModel: order,
            )),

        // Cancelled orders
        ...cancelledOrders.map((order) => OrderCard(
              orderNumber: order.id,
              status: LocaleKeys.profile_orders_cancelled.tr(),
              isCompleted: false,
              orderModel: order,
            )),
      ],
    );
  }
}
