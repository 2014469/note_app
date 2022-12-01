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
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}