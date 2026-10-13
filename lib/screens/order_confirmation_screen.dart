import 'package:flutter/material.dart';

import '../utils/cart_styles.dart';
import '../widgets/pink_button.dart';

/// Screen 9 – Order Confirmation.
///
/// [onViewOrderDetails] lets Zizi's Track Order screen be plugged in at
/// integration time, e.g.
///   OrderConfirmationScreen(
///     orderId: id,
///     onViewOrderDetails: () => Navigator.push(context, MaterialPageRoute(
///       builder: (_) => TrackOrderScreen(orderId: id))),
///   )
/// Until then a placeholder message is shown.
class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  final VoidCallback? onViewOrderDetails;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    this.onViewOrderDetails,
  });

  void _goHome(BuildContext context) =>
      Navigator.of(context).popUntil((route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // the order is placed; Back should go Home, not to checkout
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const _Confetti(),
            const Align(
              alignment: Alignment.bottomCenter,
              child: _BabyInClouds(),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.4, end: 1),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.elasticOut,
                        builder: (_, scale, child) =>
                            Transform.scale(scale: scale, child: child),
                        child: Container(
                          width: 104,
                          height: 104,
                          decoration: const BoxDecoration(
                            color: CartColors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Order Placed Successfully!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: CartColors.navy,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Your order has been confirmed and\nwill be delivered soon.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: CartColors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Order #$orderId',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: CartColors.navy,
                        ),
                      ),
                      const SizedBox(height: 28),
                      PinkButton(
                        label: 'View Order Details',
                        onPressed: onViewOrderDetails ??
                                () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Track Order screen not connected yet',
                                ),
                              ),
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _goHome(context),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(
                            color: CartColors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 140), // room for the illustration
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Scattered pastel dots, like the confetti in the design.
class _Confetti extends StatelessWidget {
  const _Confetti();

  static const _dots = <(double, double, double, Color)>[
    (-0.85, -0.85, 8, Color(0xFFB9A7F5)),
    (-0.3, -0.92, 6, Color(0xFFFFC857)),
    (0.55, -0.88, 7, Color(0xFF8ED1B4)),
    (0.9, -0.7, 9, Color(0xFFF59BBB)),
    (-0.92, -0.45, 7, Color(0xFF8EC5FF)),
    (0.85, -0.35, 6, Color(0xFFB9A7F5)),
    (-0.7, 0.05, 6, Color(0xFFF59BBB)),
    (0.78, 0.1, 8, Color(0xFFFFC857)),
    (-0.25, -0.62, 5, Color(0xFF8EC5FF)),
    (0.35, -0.55, 5, Color(0xFFF59BBB)),
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          for (final d in _dots)
            Align(
              alignment: Alignment(d.$1, d.$2),
              child: Container(
                width: d.$3,
                height: d.$3,
                decoration: BoxDecoration(color: d.$4, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}

/// Simple stand-in for the baby-on-a-cloud illustration at the bottom.
/// Swap for the real asset: Image.asset('assets/images/baby_cloud.png').
class _BabyInClouds extends StatelessWidget {
  const _BabyInClouds();

  @override
  Widget build(BuildContext context) {
    const cloud = Color(0xFFFCE4EE);
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(bottom: -30, left: -20, child: _blob(150, cloud)),
          Positioned(bottom: -40, child: _blob(190, const Color(0xFFFDEFF5))),
          Positioned(bottom: -30, right: -20, child: _blob(150, cloud)),
          Positioned(
            bottom: 36,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE6D5),
                shape: BoxShape.circle,
                border: Border.all(color: CartColors.blue, width: 4),
              ),
              child: const Icon(
                Icons.child_care_rounded,
                size: 38,
                color: CartColors.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}