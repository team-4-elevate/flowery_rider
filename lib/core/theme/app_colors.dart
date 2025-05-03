import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const scaffoldBackground = Color(0xffF9F9F9);

  static const primary = MaterialColor(
    0xffD21E6A,
    <int, Color>{
      10: Color(0xfff6d2e1),
      20: Color(0xfff0b4cd),
      30: Color(0xffe98fb5),
      40: Color(0xffe1699c),
      50: Color(0xffda4483),
      60: Color(0xffaf1958),
      70: Color(0xff8c1447),
      80: Color(0xff690f35),
      90: Color(0xff460a23),
      100: Color(0xff2a0615),
    },
  );
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
