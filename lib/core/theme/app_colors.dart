import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const scaffoldBackground = Color(0xffF9F9F9);

  static const primary = Color.fromARGB(255, 56, 25, 38);
  static const black = MaterialColor(
    0xff0C1015,
    <int, Color>{
      10: Color(0xff0C1015),
    },
  );
  static const white = MaterialColor(
    0xffF9F9F9,
    <int, Color>{
      10: Color(0xfffefefe),
      20: Color(0xfffdfdfd),
      30: Color(0xfffcfcfc),
      40: Color(0xfffbfbfb),
      50: Color(0xfffafafa),
      60: Color(0xffd0d0d0),
      70: Color(0xffa6a6a6),
      80: Color(0xff7d7d7d),
      90: Color(0xff535353),
      100: Color(0xff323232),
    },
  );

  // static const black = Color(0xff0C1015);

  static const grey = Color(0xff535353);

  static const disableButton = Color(0xff878787);

  static const error = Color(0xffCC1010);
  static const success = Color(0xff0CB359);
  static const lightPink = Color(0xffF9ECF0);
}
