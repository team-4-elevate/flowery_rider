// features/Home_layout/presentation/page/home_layout.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/Home_layout/domain/entities/order_entity.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_cubit.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_states.dart';
import 'package:flowery_rider/features/Home_layout/presentation/widgets/error_content.dart';
import 'package:flowery_rider/features/Home_layout/presentation/widgets/order_content.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getPendingOrders();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Text(
                  LocaleKeys.home_app_title.tr(),
                  style: getBoldStyle(
                    fontSize: 22.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeStates>(
                  builder: (context, state) {
                    if (state.homeState is BaseLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      );
                    } else if (state.homeState is BaseErrorState) {
                      final error =
                          (state.homeState as BaseErrorState).errorMessage;
                      return ErrorContent(error: error);
                    } else {
                      return BlocBuilder<HomeCubit, HomeStates>(
                        builder: (context, _) {
                          final visibleOrders =
                              context.read<HomeCubit>().visibleOrders;

                          return RefreshIndicator(
                            onRefresh: () =>
                                context.read<HomeCubit>().getPendingOrders(),
                            child: visibleOrders.isEmpty
                                ? LayoutBuilder(
                                    builder: (context, constraints) {
                                      return ListView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        children: [
                                          SizedBox(
                                            height: constraints.maxHeight,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .local_florist_outlined,
                                                    color: AppColors.primary,
                                                    size: 48.sp,
                                                  ),
                                                  SizedBox(height: 16.h),
                                                  Text(
                                                    LocaleKeys
                                                        .home_no_pending_orders
                                                        .tr(),
                                                    style: getMediumStyle(
                                                        fontSize: 16.sp,
                                                        color: AppColors.grey),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Text(
                                                    LocaleKeys
                                                        .home_pull_to_refresh
                                                        .tr(),
                                                    style: getRegularStyle(
                                                        fontSize: 14.sp,
                                                        color: AppColors.grey),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : _buildOrdersList(visibleOrders, context),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<OrderEntity> orders, BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderContent(
          storeAddress: order.storeAddress,
          userName: order.userName,
          userAddress: order.userAddress,
          price: order.price,
          onAccept: () => _acceptOrder(order, context),
          onReject: () => _rejectOrder(order, context),
        );
      },
    );
  }

  void _acceptOrder(OrderEntity order, BuildContext context) {
    GetIt.I<DialogUtils>().showSnackBar(
      textColor: AppColors.primary,
      message: LocaleKeys.home_accept_order_message.tr(),
      context: context,
    );
  }

  void _rejectOrder(OrderEntity order, BuildContext context) {
    context.read<HomeCubit>().rejectOrder(order.id);
  }
}
