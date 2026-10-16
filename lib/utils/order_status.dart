import 'package:flutter/material.dart';

/// The order statuses the API uses, with friendly labels and colours.
/// Reusable by anyone showing order status (history, tracking, admin).
class OrderStatus {
  static const List<String> all = [
    'Confirmed',
    'Shipped',
    'OutForDelivery',
    'Delivered',
  ];

  static String label(String status) {
    switch (status) {
      case 'OutForDelivery':
        return 'Out for delivery';
      default:
        return status;
    }
  }

  static Color color(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.orange.shade800;
      case 'Shipped':
        return Colors.blue.shade700;
      case 'OutForDelivery':
        return Colors.purple.shade600;
      case 'Delivered':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}