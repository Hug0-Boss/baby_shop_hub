import 'package:flutter/material.dart';

import '../utils/cart_styles.dart';

/// Subtotal / Delivery Fee / Total block shared by the Cart and Checkout screens.
class PriceSummary extends StatelessWidget {
  final int subtotal;
  final int delivery;
  final int total;

  const PriceSummary({
    super.key,
    required this.subtotal,
    required this.delivery,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row('Subtotal', formatNaira(subtotal)),
        const SizedBox(height: 8),
        _row('Delivery Fee', formatNaira(delivery)),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 1, color: CartColors.border),
        ),
        _row('Total', formatNaira(total), bold: true),
      ],
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 16 : 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: bold ? CartColors.navy : CartColors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 20 : 14,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: CartColors.navy,
          ),
        ),
      ],
    );
  }
}