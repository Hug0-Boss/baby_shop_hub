import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

/// App-wide cart state. No extra packages needed – it's a plain
/// [ChangeNotifier] singleton, so any screen can do:
///
///   CartService.instance.addItem(CartItem(id: 'p1', name: 'Pampers', price: 12500));
///
/// and any widget wrapped in a `ListenableBuilder(listenable: CartService.instance, ...)`
/// rebuilds automatically.
class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  static const int deliveryFee = 2000; // ₦
  static const int maxQuantity = 10;

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  /// Total number of units (used for the cart badge on the nav bar).
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  int get subtotal => _items.fold(0, (sum, i) => sum + i.lineTotal);
  int get delivery => _items.isEmpty ? 0 : deliveryFee;
  int get total => subtotal + delivery;

  void addItem(CartItem item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      final existing = _items[index];
      existing.quantity =
          (existing.quantity + item.quantity).clamp(1, maxQuantity).toInt();
    } else {
      _items.add(item.copyWith());
    }
    notifyListeners();
  }

  void increment(String id) {
    final item = _find(id);
    if (item == null || item.quantity >= maxQuantity) return;
    item.quantity++;
    notifyListeners();
  }

  void decrement(String id) {
    final item = _find(id);
    if (item == null || item.quantity <= 1) return;
    item.quantity--;
    notifyListeners();
  }

  /// Removes an item and returns its old position so the UI can offer "Undo".
  int remove(String id) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index >= 0) {
      _items.removeAt(index);
      notifyListeners();
    }
    return index;
  }

  void restore(int index, CartItem item) {
    _items.insert(index.clamp(0, _items.length).toInt(), item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Turns the current cart into an order and empties it.
  /// TODO: replace the fake id with a real API/Firestore call when the backend is ready.
  String placeOrder() {
    final rng = Random();
    final id = 'BSH${1000000 + rng.nextInt(9000000)}';
    clear();
    return id;
  }

  /// Sample data matching the UI design – handy until Olive's screens
  /// start calling [addItem]. Remove once real add-to-cart works.
  void loadDemoItems() {
    if (_items.isNotEmpty) return;
    _items.addAll([
      CartItem(
        id: 'demo-diapers',
        name: 'Pampers Premium Care',
        variant: 'Size 3 · 52 pcs',
        price: 12500,
      ),
      CartItem(
        id: 'demo-carrier',
        name: 'Baby Carrier',
        variant: 'Black · Adjustable',
        price: 18000,
      ),
      CartItem(
        id: 'demo-bottle',
        name: 'Baby Feeding Bottle',
        variant: '250ml',
        price: 3500,
      ),
    ]);
    notifyListeners();
  }

  CartItem? _find(String id) {
    for (final i in _items) {
      if (i.id == id) return i;
    }
    return null;
  }
}