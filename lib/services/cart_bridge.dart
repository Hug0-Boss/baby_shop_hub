import 'package:flutter/material.dart';
import '../models/product.dart';

/// The ONE place the browse screens talk to the shopping cart.
/// Mojeed: replace the body with the real cart call, e.g. CartService.add(p, size, qty).
void addToCart(BuildContext context, Product p, {String? size, int qty = 1}) {
  final sizeText = size == null ? '' : ' ($size)';
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Added $qty x ${p.name}$sizeText to cart')),
  );
}
