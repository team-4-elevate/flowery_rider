// features/Home_layout/presentation/page/order_details.dart
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: getMediumStyle(
            fontSize: 18.sp,
            color: AppColors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pushNamed(context, Routes.navbar),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID
            Text(
              'Order #12345',
              style: getBoldStyle(
                fontSize: 18.sp,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 16.h),

            // Status
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'In Progress',
                style: getMediumStyle(
                  fontSize: 14.sp,
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Order Details
            _buildSectionTitle('Order Details'),
            _buildDetailRow('Date', '11 May 2025'),
            _buildDetailRow('Total Amount', 'EGP 250'),
            _buildDetailRow('Payment Method', 'Cash on Delivery'),
            SizedBox(height: 16.h),

            // Store Details
            _buildSectionTitle('Store Information'),
            _buildDetailRow('Store Name', 'Flowery Store'),
            _buildDetailRow('Address', '123 Fixed Address, City, Country'),
            _buildDetailRow('Phone', '+20 123 456 7890'),
            SizedBox(height: 16.h),

            // Customer Details
            _buildSectionTitle('Customer Information'),
            _buildDetailRow('Name', 'Elevate Tech'),
            _buildDetailRow('Address', '123 Fixed Address, City, Country'),
            SizedBox(height: 32.h),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Order completed successfully!')),
                  );
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.of(context).pop();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'Mark as Delivered',
                  style: getMediumStyle(
                    fontSize: 16.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: getBoldStyle(
          fontSize: 16.sp,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 8.w),
          Text(
            '$label: ',
            style: getMediumStyle(
              fontSize: 14.sp,
              color: AppColors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: getRegularStyle(
                fontSize: 14.sp,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
