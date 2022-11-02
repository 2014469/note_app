import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class

  static const primary = Color(0xFFF88379);
  static const yellowGold = Color(0xFFF8C278);
  static const background = Color(0xFFF5F5F5);

  static const Map<int, Color> gray = <int, Color>{
    0: Color(0xFFFFFFFF),
    5: Color(0xFFFDFDFD),
    10: Color(0xFFE5E5E5),
    20: Color(0xFFCCCCCC),
    30: Color(0xFFB3B3B3),
    40: Color(0xFF999999),
    50: Color(0xFF808080),
    60: Color(0xFF666666),
    70: Color(0xFF4D4D4D),
    80: Color(0xFF333333),
    90: Color(0xFF1A1A1A),
    100: Color(0xFF000000)
  };
}
