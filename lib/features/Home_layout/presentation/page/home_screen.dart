import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_cubit.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_states.dart';
import 'package:flowery_rider/features/Home_layout/presentation/widgets/error_content.dart';
import 'package:flowery_rider/features/Home_layout/presentation/widgets/order_content.dart';
import 'package:flowery_rider/features/order_details/domain/entities/order_status_enum.dart';
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
    context.read<HomeCubit>().listenToOrders();
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

                          return state.firebaseOrders == null ||
                                  state.firebaseOrders!.isEmpty
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
                                                  Icons.local_florist_outlined,
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
                              : _buildOrdersList(
                                  state.firebaseOrders!, context);
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

  Widget _buildOrdersList(List<DriverOrderModel> orders, BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final DriverOrderModel order = orders[index];
        return OrderContent(
          storeAddress: order.pickupAddress?.address ?? 'address',
          userName: (order.customer?.firstName ?? 'name'),
          userAddress: order.customer?.address ?? 'address',
          price: order.totalPrice,
          onAccept: () => _acceptOrder(order, context),
          onReject: () => _rejectOrder(order, context),
        );
      },
    );
  }

  Future<void> _acceptOrder(
      DriverOrderModel order, BuildContext context) async {
    await context
        .read<HomeCubit>()
        .changeOrderStatus(orderId: order.id, status: OrderStatusEnum.accepted)
        .then(
      (_) {
        if (mounted) {
          GetIt.I<DialogUtils>().showSnackBar(
            textColor: Colors.green,
            message: LocaleKeys.home_accept_order_message.tr(),
            context: context,
          );
          Navigator.of(context).pushNamed(Routes.orderDetails,
              arguments: order.copyWith(status: OrderStatusEnum.accepted));
        }
      },
    );
  }

  Future<void> _rejectOrder(
      DriverOrderModel order, BuildContext context) async {
    GetIt.I<DialogUtils>().showSnackBar(
      textColor: Colors.green,
      message: LocaleKeys.home_accept_order_message.tr(),
      context: context,
    );
    await context.read<HomeCubit>().rejectOrder(order.id);
  }
}
