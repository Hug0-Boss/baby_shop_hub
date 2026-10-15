import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../utils/cart_styles.dart';

/// One product row in the cart: image, name, variant, price,
/// quantity stepper and delete button.
class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductImage(url: item.imageUrl),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: CartColors.navy,
                  ),
                ),
                if (item.variant.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.variant,
                    style: const TextStyle(fontSize: 12, color: CartColors.blue),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  formatNaira(item.price),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: CartColors.navy,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QuantityStepper(
                      quantity: item.quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Remove',
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: CartColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? url;
  const _ProductImage({this.url});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: CartColors.pinkSoft,
      alignment: Alignment.center,
      child: const Icon(
        Icons.child_friendly_outlined,
        size: 32,
        color: CartColors.pink,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 84,
        height: 84,
        child: url == null
            ? placeholder
            : Image.network(
          url!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CartColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CartColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, quantity > 1 ? onDecrement : null),
          SizedBox(
            width: 28,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: CartColors.navy,
              ),
            ),
          ),
          _btn(Icons.add, onIncrement),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? CartColors.border : CartColors.navy,
        ),
      ),
    );
  }
}