import 'package:flutter/material.dart';

import '../services/cart_service.dart';
import '../utils/cart_styles.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/pink_button.dart';
import '../widgets/price_summary.dart';
import 'checkout_screen.dart';

/// Screen 7 – Shopping Cart.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: CartColors.navy,
        title: const Text(
          'My Cart',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          if (cart.isEmpty) return const _EmptyCart();

          final items = cart.items;
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: CartColors.border),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return CartItemTile(
                      key: ValueKey(item.id),
                      item: item,
                      onIncrement: () => cart.increment(item.id),
                      onDecrement: () => cart.decrement(item.id),
                      onDelete: () => _removeWithUndo(context, item.id),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: CartColors.border)),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PriceSummary(
                        subtotal: cart.subtotal,
                        delivery: cart.delivery,
                        total: cart.total,
                      ),
                      const SizedBox(height: 16),
                      PinkButton(
                        label: 'Proceed to Checkout',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CheckoutScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _removeWithUndo(BuildContext context, String id) {
    final cart = CartService.instance;
    final removed = cart.items.firstWhere((i) => i.id == id);
    final index = cart.remove(id);

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${removed.name} removed'),
          action: SnackBarAction(
            label: 'UNDO',
            textColor: CartColors.pinkDisabled,
            onPressed: () => cart.restore(index, removed),
          ),
        ),
      );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: CartColors.pinkSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: CartColors.pink,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: CartColors.navy,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add something little and lovely\nto get started.',
              textAlign: TextAlign.center,
              style: TextStyle(color: CartColors.grey),
            ),
            const SizedBox(height: 24),
            if (Navigator.of(context).canPop())
              SizedBox(
                width: 200,
                child: PinkButton(
                  label: 'Start Shopping',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}