// core/widget/dialog_utils.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';

@singleton
class DialogUtils {
  // Loading dialog tracking
  bool _isLoading = false;
  BuildContext? _loadingContext;

  void showSnackBar({
    required Color textColor,
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 5),
  }) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: textColor,
                size: 24.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black.withAlpha(204),
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 8,
          margin: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      );
  }

  void showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(title)),
          content: Text(content),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('dialogs.error.ok'.tr()),
            ),
          ],
        );
      },
    );
  }

  // Show loading dialog
  void showLoading(BuildContext context) {
    if (_isLoading) return;

    _isLoading = true;
    _loadingContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 16.h),
                Text('Please wait...', style: TextStyle(fontSize: 16.sp)),
              ],
            ),
          ),
        );
      },
    );
  }

  // Hide loading dialog
  void hideLoading(BuildContext context) {
    if (!_isLoading) return;

    _isLoading = false;

    if (_loadingContext != null && Navigator.canPop(_loadingContext!)) {
      Navigator.pop(_loadingContext!);
      _loadingContext = null;
    }
  }
}
