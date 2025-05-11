// features/Home_layout/presentation/page/home_layout.dart
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/features/Home_layout/data/model/order_model.dart';
import 'package:flowery_rider/features/Home_layout/presentation/widgets/order_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Skeleton data - in a real app, this would come from API via BLoC/Cubit
    final List<OrderModel> orders = [
      OrderModel(
        storeAddress: '20th st,Sheikh Zayed, Giza',
        userName: 'Nour mohamed',
        userAddress: '20th st,Sheikh Zayed, Giza',
        price: 3000,
      ),
      OrderModel(
        storeAddress: '20th st,Sheikh Zayed, Giza',
        userName: 'Nour mohamed',
        userAddress: '20th st,Sheikh Zayed, Giza',
        price: 3000,
      ),
      OrderModel(
        storeAddress: '20th st,Sheikh Zayed, Giza',
        userName: 'Nour mohamed',
        userAddress: '20th st,Sheikh Zayed, Giza',
        price: 3000,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Text(
                'Flowery rider',
                style: getBoldStyle(
                  fontSize: 22.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderContent(
                    storeAddress: order.storeAddress,
                    userName: order.userName,
                    userAddress: order.userAddress,
                    price: order.price,
                    onAccept: () => _acceptOrder(order),
                    onReject: () => _rejectOrder(order),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _acceptOrder(OrderModel order) {
    // In a real app, this would dispatch an event to a BLoC/Cubit
    // which would handle the API call to accept the order
    debugPrint('Accepted order for ${order.userName}');
  }

  void _rejectOrder(OrderModel order) {
    // In a real app, this would dispatch an event to a BLoC/Cubit
    // which would handle the API call to reject the order
    debugPrint('Rejected order for ${order.userName}');
  }
}
