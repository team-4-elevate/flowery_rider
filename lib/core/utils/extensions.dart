import 'dart:async';

import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

extension BuildContextExtension on BuildContext {
  // Screen dimensions
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // Percentage of screen width/height
  double widthPercent(double percent) => screenWidth * percent / 100;
  double heightPercent(double percent) => screenHeight * percent / 100;

  // Responsive sizes
  double get extraSmallSize => screenWidth * 0.01;
  double get smallSize => screenWidth * 0.02;
  double get mediumSize => screenWidth * 0.04;
  double get largeSize => screenWidth * 0.06;
  double get extraLargeSize => screenWidth * 0.08;

  void showLoadingIndicator() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  void hideLoadingIndicator() {
    if (mounted && Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    }
  }

  // // Text sizes
  // double get bodyText => screenWidth * 0.035;
  // double get subheadingText => screenWidth * 0.045;
  // double get headingText => screenWidth * 0.055;

  // // Device type
  // bool get isPhone => screenWidth < 600;
  // bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  // bool get isDesktop => screenWidth >= 1200;

  // // Orientation
  // bool get isLandscape => MediaQuery.orientationOf(this) == Orientation.landscape;
  // bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;
}

extension NavigationExtension on BuildContext {
  void pop() => Navigator.pop(this);
  void goTo(Widget screen) => Navigator.push(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      );
  void goToAndRemoveUntil(Widget screen) => Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
        (route) => false,
      );
  void goToAndReplace(Widget screen) => Navigator.pushReplacement(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      );
  void goToAndReplaceUntil(Widget screen) => Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
        (route) => false,
      );
  void goToAndReplaceUntilWithArgs(Widget screen, Object args) =>
      Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
          settings: RouteSettings(arguments: args),
        ),
        (route) => false,
      );
  void goToAndReplaceUntilWithArgsAndName(Widget screen, Object args) =>
      Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
          settings: RouteSettings(arguments: args),
        ),
        (route) => false,
      );
  void goToAndReplaceUntilWithName(Widget screen) =>
      Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
        (route) => false,
      );
  void goToAndReplaceUntilWithNameAndArgs(Widget screen, Object args) =>
      Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
          settings: RouteSettings(arguments: args),
        ),
        (route) => false,
      );
  void goToAndReplaceUntilWithNameAndArgsAndName(Widget screen, Object args) =>
      Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
          settings: RouteSettings(arguments: args),
        ),
        (route) => false,
      );
}
