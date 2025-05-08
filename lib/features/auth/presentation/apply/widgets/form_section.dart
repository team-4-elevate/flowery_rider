// features/auth/presentation/widgets/apply_widgets/form_section.dart
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';

class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final double spacing;

  const FormSection({
    super.key,
    required this.title,
    required this.children,
    this.spacing = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getMediumStyle(
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 15.h),
        ...children
            .expand((child) => [child, SizedBox(height: spacing.h)])
            .toList()
          ..removeLast(),
      ],
    );
  }
}
