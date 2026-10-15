/// Shared product model. Ugo's original fields (id, name, price, stock) are unchanged.
/// The extra fields all have defaults, so Product(id:, name:, price:, stock:) still works.
class Product {
  final String id;
  String name;
  double price;
  int stock;
  String category; // Clothing, Diapers, Toys or Feeding
  String subCategory; // '' normally, or 'Footwear' (shown under Clothing)
  String ageGroup; // '0-6 Months' or '6-12 Months'
  String description;
  List<String> sizes; // empty list = no size picker (e.g. toys)
  double rating;
  int reviewCount;
  bool isBestSeller;
  bool onSale;
  String? imagePath; // null = show the grey placeholder

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.category = 'Clothing',
    this.subCategory = '',
    this.ageGroup = '0-6 Months',
    this.description = '',
    this.sizes = const [],
    this.rating = 4.5,
    this.reviewCount = 0,
    this.isBestSeller = false,
    this.onSale = false,
    this.imagePath,
  });

  /// Picture shown for this product: imagePath if set, otherwise assets/images/products/<id>.jpg
  String get image => imagePath ?? 'assets/images/products/$id.jpg';

  String get priceText => '\$${price.toStringAsFixed(2)}';
}

class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int rating; // 1 to 5
  final String comment;

  const Review({
    required this.id,
    required this.productId,
    required this.userId,
    this.userName = 'Customer',
    required this.rating,
    required this.comment,
  });
}
