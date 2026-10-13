/// A single line in the shopping cart.
///
/// Kept independent of Olive's `product.dart` so the two modules don't block
/// each other. When Olive's Product Details screen adds to cart, it just builds
/// a [CartItem] from its product (see `CartService.addItem`).
class CartItem {
  final String id; // product id
  final String name;
  final String variant; // e.g. "Size 3", "Black", "250ml"
  final int price; // unit price in naira
  final String? imageUrl; // optional; a placeholder icon is shown if null
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.variant = '',
    this.imageUrl,
    this.quantity = 1,
  });

  int get lineTotal => price * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
    id: id,
    name: name,
    price: price,
    variant: variant,
    imageUrl: imageUrl,
    quantity: quantity ?? this.quantity,
  );
}