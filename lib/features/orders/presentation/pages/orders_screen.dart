// features/orders/presentation/pages/orders_screen.dart
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/features/orders/presentation/widgets/order_card.dart';
import 'package:flowery_rider/features/orders/presentation/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //-------------------------------------------------summary cards
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      count: 4,
                      status: 'Cancelled',
                      statusIcon: Icons.cancel_outlined,
                      statusColor: AppColors.error,
                      backgroundColor: AppColors.lightPink,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: SummaryCard(
                      count: 100,
                      status: 'Completed',
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
                'Recent orders',
                style: getBoldStyle(color: AppColors.black, fontSize: 16.sp),
              ),
              SizedBox(height: 16.h),
              OrderCard(
                orderNumber: '123456',
                status: 'Completed',
                isCompleted: true,
              ),
              OrderCard(
                orderNumber: '123456',
                status: 'Cancelled',
                isCompleted: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
