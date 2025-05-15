import 'dart:developer';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_cubit.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class OrderDetailsStepsWidget extends StatefulWidget {
  const OrderDetailsStepsWidget({
    super.key,
  });

  @override
  State<OrderDetailsStepsWidget> createState() =>
      _OrderDetailsStepsWidgetState();
}

class _OrderDetailsStepsWidgetState extends State<OrderDetailsStepsWidget> {
  @override
  Widget build(BuildContext context) {
    final totalSteps = 5;

    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (p, c) => p.currentStep != c.currentStep,
      builder: (context, state) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            context.read<HomeCubit>().changeCurrentStep(0);
          },
          child: Row(
            children: List.generate(
              totalSteps,
              (index) {
                log('message');
                log(index.toString());
                log(state.currentStep.toString());
                return Expanded(
                  child: Container(
                    height: 4.h,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: state.currentStep == index
                          ? Color(0xFF0CB359)
                          : AppColors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
