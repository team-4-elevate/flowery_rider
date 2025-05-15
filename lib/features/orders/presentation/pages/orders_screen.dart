// features/orders/presentation/pages/orders_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:flowery_rider/features/orders/presentation/cubit/orders_states.dart';
import 'package:flowery_rider/features/orders/presentation/widgets/order_card.dart';
import 'package:flowery_rider/features/orders/presentation/widgets/summary_card.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersStates>(
      builder: (context, state) {
        final completedCount = state.completedOrders.length;
        final cancelledCount = state.cancelledOrders.length;
        
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            appBar: AppBar(
              title: Text(LocaleKeys.orders_title.tr()),
              automaticallyImplyLeading: false,
              surfaceTintColor: Colors.transparent,
            ),
            body: state.ordersState is BaseErrorState
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
                              count: cancelledCount,
                              status: LocaleKeys.orders_cancelled.tr(),
                              statusIcon: Icons.cancel_outlined,
                              statusColor: AppColors.error,
                              backgroundColor: AppColors.lightPink,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: SummaryCard(
                              count: completedCount,
                              status: LocaleKeys.orders_completed.tr(),
                              statusIcon: Icons.check_circle_outline,
                              statusColor: AppColors.success,
                              backgroundColor: AppColors.success.withAlpha(20),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      //-------------------------------------------------recent orders
                      Text(
                        LocaleKeys.orders_recent_orders.tr(),
                        style: getBoldStyle(color: AppColors.black, fontSize: 16.sp),
                      ),
                      SizedBox(height: 16.h),
                      _buildOrdersList(state),
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
            LocaleKeys.orders_failed_to_load.tr(),
            style: getMediumStyle(color: AppColors.error, fontSize: 16.sp),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () => context.read<OrdersCubit>().fetchOrders(),
            child: Text(LocaleKeys.orders_retry.tr(),
                style: getMediumStyle(
                    color: AppColors.primary, fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

   // ------------------------------------------------- loading indicator during initial data fetch
  Widget _buildOrdersList(OrdersStates state) {
    if (state.ordersState is BaseLoadingState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.orders_loading.tr(),
              style: getMediumStyle(color: AppColors.grey, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }
    if (state.ordersState is BaseSuccessState &&
        state.completedOrders.isEmpty &&
        state.cancelledOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48.sp, color: AppColors.grey),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.orders_no_orders_found.tr(),
              style: getMediumStyle(color: AppColors.grey, fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              LocaleKeys.orders_no_orders_message.tr(),
              style: getRegularStyle(color: AppColors.grey, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Completed orders
        ...state.completedOrders.map((order) => OrderCard(
              orderNumber: order.id,
              status: LocaleKeys.orders_completed.tr(),
              isCompleted: true,
              orderModel: order,
            )),

        // Cancelled orders
        ...state.cancelledOrders.map((order) => OrderCard(
              orderNumber: order.id,
              status: LocaleKeys.orders_cancelled.tr(),
              isCompleted: false,
              orderModel: order,
            )),
      ],
    );
  }
}
