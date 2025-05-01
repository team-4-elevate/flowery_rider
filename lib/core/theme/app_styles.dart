import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_fonts.dart';

TextStyle _getTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
}) =>
    TextStyle(
      fontSize: fontSize,
      fontFamily: AppFonts.interFont,
      color: color,
      fontWeight: fontWeight,
    );

TextStyle getLightStyle({
  double? fontSize,
  double? height,
  required Color color,
}) =>
    _getTextStyle(
      fontSize: fontSize ?? 12.sp,
      fontWeight: FontWeight.w300,
      color: color,
    );

TextStyle getRegularStyle({
  double? fontSize,
  double? height,
  required Color color,
}) =>
    _getTextStyle(
      fontSize: fontSize ?? 12.sp,
      fontWeight: FontWeight.w400,
      color: color,
    );

TextStyle getMediumStyle({
  double? fontSize,
  double? height,
  required Color color,
}) =>
    _getTextStyle(
      fontSize: fontSize ?? 12.sp,
      fontWeight: FontWeight.w500,
      color: color,
    );

TextStyle getBoldStyle({
  double? fontSize,
  double? height,
  required Color color,
}) =>
    _getTextStyle(
      fontSize: fontSize ?? 12.sp,
      fontWeight: FontWeight.w700,
      color: color,
    );

TextStyle getExtraBoldStyle({
  double? fontSize,
  double? height,
  required Color color,
}) =>
    _getTextStyle(
      fontSize: fontSize ?? 12.sp,
      fontWeight: FontWeight.w800,
      color: color,
    );
TextStyle getBlackStyle({
  double? fontSize,
  double? height,
  required Color color,
}) =>
    _getTextStyle(
      fontSize: fontSize ?? 12.sp,
      fontWeight: FontWeight.w900,
      color: color,
    );
TextStyle getTextUnderLine({
  double? fontSize,
  required Color color,
}) =>
    TextStyle(
      color: color,
      fontSize: fontSize ?? 12.sp,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
      decorationColor: color,
    );
