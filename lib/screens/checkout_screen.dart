import 'package:baby_shop_hub/screens/cart_screen.dart';
import 'package:flutter/material.dart';

import '../models/delivery_address.dart';
import '../services/cart_service.dart';
import '../utils/cart_styles.dart';
import '../widgets/pink_button.dart';
import '../widgets/price_summary.dart';
import 'order_confirmation_screen.dart';

enum PaymentMethod { card, payOnDelivery, bankTransfer }

extension on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.card:
        return 'Card Payment (Debit/Credit)';
      case PaymentMethod.payOnDelivery:
        return 'Pay on Delivery';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.card:
        return Icons.credit_card_rounded;
      case PaymentMethod.payOnDelivery:
        return Icons.payments_outlined;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance_outlined;
    }
  }
}

/// Screen 8 – Checkout.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // TODO: load saved addresses from Zizi's profile/auth service once it exists.
  final List<DeliveryAddress> _addresses = [
    const DeliveryAddress(
      id: 'addr-1',
      fullName: 'Nifemi Adeyemi',
      phone: '+234 801 234 5678',
      address: '14 Awolowo Street, Lekki Phase 1, Lagos',
    ),
  ];
  String? _selectedId = 'addr-1';
  PaymentMethod? _payment = PaymentMethod.card;
  bool _placing = false;

  DeliveryAddress? get _selectedAddress {
    for (final a in _addresses) {
      if (a.id == _selectedId) return a;
    }
    return null;
  }

  /// 0 = Address, 1 = Payment, 2 = Review
  int get _currentStep {
    if (_selectedAddress == null) return 0;
    if (_payment == null) return 1;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;
    final canPlace = _selectedAddress != null && _payment != null && !cart.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: CartColors.navy,
        title: const Text(
          'Checkout',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
                _CheckoutStepper(current: _currentStep),
                const SizedBox(height: 24),
                const _SectionTitle('Delivery Address'),
                ..._addresses.map(_addressCard),
                const SizedBox(height: 4),
                OutlinedButton(
                  onPressed: () => _openAddressSheet(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CartColors.blue,
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: CartColors.border),
                    backgroundColor: CartColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Add New Address',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 24),
                const _SectionTitle('Payment Method'),
                ...PaymentMethod.values.map(_paymentTile),
                const SizedBox(height: 24),
                const _SectionTitle('Order Summary'),
                ListenableBuilder(
                  listenable: cart,
                  builder: (_, __) => PriceSummary(
                    subtotal: cart.subtotal,
                    delivery: cart.delivery,
                    total: cart.total,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: CartColors.border)),
            ),
            child: SafeArea(
              top: false,
              child: PinkButton(
                label: 'Place Order',
                loading: _placing,
                onPressed: canPlace ? _placeOrder : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- address ----------

  Widget _addressCard(DeliveryAddress a) {
    final selected = a.id == _selectedId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _selectedId = a.id),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? CartColors.pink : CartColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: CartColors.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a.phone,
                      style: const TextStyle(
                        fontSize: 13,
                        color: CartColors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      a.address,
                      style: const TextStyle(
                        fontSize: 13,
                        color: CartColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: CartColors.blue),
                onSelected: (value) {
                  if (value == 'edit') {
                    _openAddressSheet(existing: a);
                  } else {
                    setState(() {
                      _addresses.removeWhere((x) => x.id == a.id);
                      if (_selectedId == a.id) {
                        _selectedId =
                        _addresses.isEmpty ? null : _addresses.first.id;
                      }
                    });
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'remove', child: Text('Remove')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAddressSheet({DeliveryAddress? existing}) async {
    final result = await showModalBottomSheet<DeliveryAddress>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AddressSheet(existing: existing),
    );
    if (result == null || !mounted) return;

    setState(() {
      final i = _addresses.indexWhere((a) => a.id == result.id);
      if (i >= 0) {
        _addresses[i] = result;
      } else {
        _addresses.add(result);
      }
      _selectedId = result.id;
    });
  }

  // ---------- payment ----------

  Widget _paymentTile(PaymentMethod method) {
    final selected = method == _payment;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _payment = method),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? CartColors.pinkSoft : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? CartColors.pink : CartColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                method.icon,
                color: selected ? CartColors.pink : CartColors.navy,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  method.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: CartColors.navy,
                  ),
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? CartColors.pink : CartColors.border,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: CartColors.pink,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- place order ----------

  Future<void> _placeOrder() async {
    setState(() => _placing = true);

    // TODO: replace with a real API call (send address, payment method, items).
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final orderId = CartService.instance.placeOrder();

    // Remove Cart + Checkout from the stack so Back never returns to an empty cart.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(orderId: orderId),
      ),
          (route) => route.isFirst,
    );
  }
}

// ---------------------------------------------------------------------------
// Small private widgets
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: CartColors.navy,
        ),
      ),
    );
  }
}

class _CheckoutStepper extends StatelessWidget {
  final int current;
  const _CheckoutStepper({required this.current});

  static const _labels = ['Address', 'Payment', 'Review'];

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < _labels.length; i++) {
      if (i > 0) {
        children.add(
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              color: i <= current ? CartColors.pink : CartColors.border,
            ),
          ),
        );
      }
      children.add(_step(i));
    }
    return Row(children: children);
  }

  Widget _step(int i) {
    final done = i < current;
    final active = i == current;
    final highlighted = done || active;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: highlighted ? CartColors.pink : Colors.white,
            border: Border.all(
              color: highlighted ? CartColors.pink : CartColors.border,
              width: 1.5,
            ),
          ),
          child: done
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(
            '${i + 1}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: highlighted ? Colors.white : CartColors.grey,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          _labels[i],
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: highlighted ? CartColors.pink : CartColors.grey,
          ),
        ),
      ],
    );
  }
}

class _AddressSheet extends StatefulWidget {
  final DeliveryAddress? existing;
  const _AddressSheet({this.existing});

  @override
  State<_AddressSheet> createState() => _AddressSheetState();
}

class _AddressSheetState extends State<_AddressSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.fullName ?? '');
    _phone = TextEditingController(text: widget.existing?.phone ?? '');
    _address = TextEditingController(text: widget.existing?.address ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id = widget.existing?.id ??
        'addr-${DateTime.now().microsecondsSinceEpoch}';
    Navigator.of(context).pop(
      DeliveryAddress(
        id: id,
        fullName: _name.text.trim(),
        phone: _phone.text.trim(),
        address: _address.text.trim(),
      ),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: CartColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: CartColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: CartColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: CartColors.pink, width: 1.5),
    ),
  );

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existing == null ? 'Add New Address' : 'Edit Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: CartColors.navy,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: _decoration('Full name'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: _decoration('Phone number'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (v.replaceAll(RegExp(r'\D'), '').length < 10) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              maxLines: 2,
              decoration: _decoration('Street, area, city'),
              validator: _required,
            ),
            const SizedBox(height: 20),
            PinkButton(label: 'Save Address', onPressed: _save),
          ],
        ),
      ),
    );
  }
}