// features/orders/presentation/pages/completed_orders_details.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/widget/address_card.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/app_data/shared_models/orders/driver_order_model.dart';
import 'package:flowery_rider/features/order_details/domain/entities/order_status_enum.dart';
import 'package:flowery_rider/features/order_details/domain/entities/payment_type_enum.dart';
import 'package:flowery_rider/features/orders/presentation/widgets/info_row.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompletedOrdersDetails extends StatelessWidget {
  final DriverOrderModel? order;

  const CompletedOrdersDetails({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(LocaleKeys.completed_orders_details_title.tr()),
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------------------------------------------------ Order Status and Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      order?.status == OrderStatusEnum.delivered ||
                              order?.status == OrderStatusEnum.accepted
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      color: order?.status == OrderStatusEnum.delivered ||
                              order?.status == OrderStatusEnum.accepted
                          ? AppColors.success
                          : AppColors.error,
                      size: 20.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      order?.status == OrderStatusEnum.delivered ||
                              order?.status == OrderStatusEnum.accepted
                          ? LocaleKeys.orders_completed.tr()
                          : LocaleKeys.orders_cancelled.tr(),
                      style: getMediumStyle(
                        color: order?.status == OrderStatusEnum.delivered ||
                                order?.status == OrderStatusEnum.accepted
                            ? AppColors.success
                            : AppColors.error,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                Text(
                  '# ${order?.id ?? LocaleKeys.completed_orders_details_fallback_id.tr()}',
                  style:
                      getMediumStyle(color: AppColors.black, fontSize: 16.sp),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            //------------------------------------------------ Pickup Address
            Text(
              LocaleKeys.completed_orders_details_pickup_address.tr(),
              style: getRegularStyle(color: AppColors.grey, fontSize: 12.sp),
            ),
            SizedBox(height: 8.h),
            AddressCard(
              title: order?.pickupAddress?.address ??
                  LocaleKeys.completed_orders_details_fallback_store_name.tr(),
              address: order?.pickupAddress?.address ??
                  LocaleKeys.completed_orders_details_fallback_address.tr(),
              icon: Icons.store,
            ),
            SizedBox(height: 16.h),

            // //------------------------------------------------ User Address
            Text(
              LocaleKeys.completed_orders_details_user_address.tr(),
              style: getRegularStyle(color: AppColors.grey, fontSize: 12.sp),
            ),
            SizedBox(height: 8.h),
            AddressCard(
              title: order?.customer?.firstName ??
                  LocaleKeys.completed_orders_details_fallback_customer_name
                      .tr(),
              address: order?.customer?.address ??
                  LocaleKeys.completed_orders_details_fallback_address.tr(),
              icon: Icons.person,
            ),
            SizedBox(height: 24.h),

            ////------------------------------------------------ Order Details
            Text(
              LocaleKeys.completed_orders_details_order_details.tr(),
              style: getBoldStyle(color: AppColors.black, fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),

            // //------------------------------------------------Product Items
            if (order?.orderItems != null && order!.orderItems!.isNotEmpty)
              ...order!.orderItems!.map((item) => Column(
                    children: [
                      AddressCard(
                        title: item.name ??
                            LocaleKeys
                                .completed_orders_details_fallback_product_name
                                .tr(),
                        address:
                            '${LocaleKeys.completed_orders_details_currency.tr()} ${item.price?.toString() ?? LocaleKeys.completed_orders_details_fallback_price.tr()}',
                        icon: Icons.local_florist,
                        showLocationIcon: false,
                        trailing: Text(
                          'x${item.quantity?.toString() ?? LocaleKeys.completed_orders_details_fallback_quantity.tr()}',
                          style: getMediumStyle(
                              color: AppColors.primary, fontSize: 14.sp),
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ))
            else
              AddressCard(
                title: LocaleKeys.completed_orders_details_fallback_product_name
                    .tr(),
                address:
                    '${LocaleKeys.completed_orders_details_currency.tr()} ${LocaleKeys.completed_orders_details_fallback_price.tr()}',
                icon: Icons.local_florist,
                showLocationIcon: false,
                trailing: Text(
                  'x${LocaleKeys.completed_orders_details_fallback_quantity.tr()}',
                  style:
                      getMediumStyle(color: AppColors.primary, fontSize: 14.sp),
                ),
              ),
            SizedBox(height: 24.h),

            // Total Section
            InfoRow(
              label: LocaleKeys.completed_orders_details_total.tr(),
              value:
                  '${LocaleKeys.completed_orders_details_currency.tr()} ${order!.totalPrice.toString()}',),
            
            SizedBox(height: 20.h),

            // Payment Method
            InfoRow(
                label: LocaleKeys.completed_orders_details_payment_method.tr(),
                value: order?.paymentType == PaymentTypeEnum.cash
                    ? LocaleKeys.completed_orders_details_cash_on_delivery.tr()
                    : LocaleKeys.completed_orders_details_card_payment.tr()),
          ],
        ),
      ),
    );
  }
}
