import 'dart:developer';

import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../Home_layout/presentation/cubit/home_cubit.dart';
import '../../domain/entities/order_status_enum.dart';

class OrderDetailsStatusWidget extends StatelessWidget {
  final String orderId;
  final DateTime? createdAt;

  const OrderDetailsStatusWidget({
    super.key,
    required this.orderId,
    this.createdAt,
  });

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${DateFormat('dd MMM yyyy, HH:mm').format(dateTime)} AM';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) => Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.pink.withValues(alpha: 0.08),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Status : ',
                  style: getBoldStyle(
                    fontSize: 14.sp,
                    color: Colors.green,
                  ),
                ),
                Text(
                  _setStatus(context.read<HomeCubit>().state.currentStep),
                  // status.name,
                  style: getBoldStyle(
                    fontSize: 14.sp,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text(
                  'Order ID : # ',
                  style: getBoldStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
                Expanded(
                  child: Text(
                    orderId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            if (createdAt != null) ...[
              SizedBox(height: 4.h),
              Text(
                _formatDateTime(createdAt),
                style: getRegularStyle(
                  fontSize: 12.sp,
                  color: AppColors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _setStatus(int currentStep) {
    log(currentStep.toString());
    switch (currentStep) {
      case 0:
        return 'Accepted';
      case 1:
        return 'Picked up';
      case 2:
        return 'Out for delivery';
      case 3:
        return 'Arrived';
      case 4:
        return 'Delivered';
      default:
        return 'Pending';
    }
  }
}
