import 'package:flowery_rider/core/app_data/shared_models/orders/order_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/app_data/shared_models/orders/driver_order_model.dart';
import '../../../../core/app_data/shared_models/orders/order_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class OrderDetailsFullOrderWidget extends StatelessWidget {
  final double? totalPrice;
  final List<OrderItem>? orderItems;

  const OrderDetailsFullOrderWidget({
    Key? key,
    required this.orderItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = _getOrderItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order details',
          style: getBoldStyle(
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 16.h),
        ...items.map((item) => _buildOrderItem(item)),
        SizedBox(height: 16.h),
        Divider(color: AppColors.grey.withOpacity(0.3)),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: getBoldStyle(
                fontSize: 16.sp,
                color: AppColors.black,
              ),
            ),
            Text(
              'EGP ${totalPrice?.toStringAsFixed(0) ?? "0"}',
              style: getBoldStyle(
                fontSize: 16.sp,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          // Product image
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Icon(Icons.local_florist, color: AppColors.primary),
            ),
          ),
          SizedBox(width: 12.w),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'item.name',
                  style: getMediumStyle(
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  'EGP ${item.price}',
                  style: getRegularStyle(
                    fontSize: 12.sp,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Quantity
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              'x${item.quantity}',
              style: getBoldStyle(
                fontSize: 12.sp,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<OrderItem> _getOrderItems() {
    final items = <OrderItem>[];

    if (orderItems != null) {
      orderItems!.forEach((item) {
        items.add(OrderItem(
          id: item.id ?? '',
          name: 'Red roses, 15 Pink Rose Bouquet',
          price: item.price ?? 600,
          quantity: 1,
          orderProduct: OrderDmProduct(id: 'id', price: 2323),
        ));
      });
    } else {
      // Add some placeholder items if no items are available
      items.add(OrderItem(
          id: '1',
          name: 'Red roses, 15 Pink Rose Bouquet',
          price: 600,
          quantity: 1,
          orderProduct: OrderDmProduct(id: 'id', price: 200)));
      items.add(OrderItem(
          id: '2',
          name: 'Red roses, 15 Pink Rose Bouquet',
          price: 600,
          quantity: 1,
          orderProduct: OrderDmProduct(id: '2sd', price: 2312)));
    }

    return items;
  }
}

// class OrderItem {
//   final String id;
//   final String name;
//   final num price;
//   final int quantity;
//
//   OrderItem({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.quantity,
//   });
// }
