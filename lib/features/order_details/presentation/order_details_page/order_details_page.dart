import 'dart:developer';

import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_cubit.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../domain/entities/order_status_enum.dart';
import '../widgets/order_details_address_widget.dart';
import '../widgets/order_details_full_order_widget.dart';
import '../widgets/order_details_status_widget.dart';
import '../widgets/order_details_steps_widget.dart';

class OrderDetailsPage extends StatelessWidget {
  final DriverOrderModel order;
  
  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderDetailsStepsWidget(),
                    SizedBox(height: 16.h),
                    OrderDetailsStatusWidget(
                      orderId: order.id,
                      createdAt: DateTime.now(),
                    ),
                    SizedBox(height: 16.h),
                    OrderDetailsAddressWidget(
                      title: 'Pickup address',
                      address: order.pickupAddress?.address ?? 'Flowery Store',
                      isStore: true,
                    ),
                    SizedBox(height: 16.h),
                    OrderDetailsAddressWidget(
                      title: 'User address',
                      address: order.pickupAddress?.address ?? 'User Address',
                      isStore: false,
                      userName: order.customer?.firstName ?? 'ahmed',
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: OrderDetailsFullOrderWidget(
                        totalPrice: order.totalPrice,
                        orderItems: order.orderItems,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment method',
                          style: getMediumStyle(
                            fontSize: 14.sp,
                            color: AppColors.grey,
                          ),
                        ),
                        Text(
                          'Cash on delivery',
                          style: getMediumStyle(
                            fontSize: 14.sp,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: BlocBuilder<HomeCubit, HomeStates>(
                buildWhen: (p, c) => p.currentStep != c.currentStep,
                builder: (context, state) => ElevatedButton(
                  onPressed: () async => _setOrderStatus(context, state),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.currentStep == 4
                        ? Colors.grey
                        : AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    _setButtonTitle(
                      state.currentStep,
                    ),
                    style: getBoldStyle(
                      fontSize: 16.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _setButtonTitle(int currentStep) {
    switch (currentStep) {
      case 0:
        return 'Arrived at Pickup point';
      case 1:
        return 'Start deliver';
      case 2:
        return 'Arrived to user';
      case 3 || 4:
        return 'Delivered to user';
      default:
        return 'Accept Order';
    }
  }

  OrderStatusEnum _getNextStatus(HomeStates state) {
    // switch (currentStatus) {
    //   case OrderStatusEnum.pending:
    //     return OrderStatusEnum.accepted;
    //   case OrderStatusEnum.accepted:
    //     return OrderStatusEnum.pickedUp;
    //   case OrderStatusEnum.pickedUp:
    //     return OrderStatusEnum.outForDelivery;
    //   case OrderStatusEnum.outForDelivery:
    //     return OrderStatusEnum.arrived;
    //   case OrderStatusEnum.arrived:
    //     return OrderStatusEnum.delivered;
    //   default:
    //     return currentStatus;
    // }
    switch (state.currentStep) {
      case 0:
        return OrderStatusEnum.pickedUp;
      case 1:
        return OrderStatusEnum.outForDelivery;
      case 2:
        return OrderStatusEnum.arrived;
      case 3:
        return OrderStatusEnum.delivered;
      case 4:
        return OrderStatusEnum.delivered;
      default:
        return OrderStatusEnum.accepted;
    }
  }

  Future<void> _setOrderStatus(BuildContext context, HomeStates state) async {
    if (state.currentStep == 4) return;
    final cubit = context.read<HomeCubit>();
    log(order.status?.name ?? '22');
    log('33');
    final nextStatus = _getNextStatus(state);
    log('newd');
    log(nextStatus.name);
    await cubit.changeOrderStatus(
      orderId: order.id,
      status: nextStatus,
    );
  }
}
