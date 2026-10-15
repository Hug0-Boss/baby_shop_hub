import 'package:flutter/material.dart';

/// Colours sampled from the BabyShopHub design.
/// If the team later adds a shared theme in utils/, swap these for it.
class CartColors {
  static const pink = Color(0xFFF06CA0);
  static const pinkSoft = Color(0xFFFFEEF4);
  static const pinkDisabled = Color(0xFFF8BBD3);
  static const blue = Color(0xFF4A9BFF);
  static const blueSoft = Color(0xFFEAF3FF);
  static const navy = Color(0xFF1F2A44);
  static const grey = Color(0xFF8A94A6);
  static const border = Color(0xFFE6E9F2);
  static const surface = Color(0xFFF7F8FC);
  static const green = Color(0xFF2BAE7A);
}

/// 36000 -> "₦36,000"
String formatNaira(num amount) {
  final digits = amount.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    buf.write(digits[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(',');
  }
  return '₦$buf';
}