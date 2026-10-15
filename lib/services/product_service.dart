import '../models/product.dart';

/// Sample data for now. When the team picks a database, only this file changes.
///
/// To add a product: copy any Product(...) line below, paste it under the last
/// one, give it a NEW id (the next number in quotes) and change the other fields.
class ProductService {
  static const categories = ['Clothing', 'Diapers', 'Toys', 'Feeding'];

  /// Zizi: set these after login so new reviews and "My Reviews" use the real user.
  static String currentUserId = '1';
  static String currentUserName = 'You';

  static const _clothesSizes = ['0-3M', '3-6M', '6-12M', '12-18M'];
  static const _toddlerSizes = ['1-2Y', '2-3Y', '3-4Y'];
  static const _shoeSizes = ['Size 3', 'Size 4', 'Size 5', 'Size 6'];

  static final List<Product> products = [
    // ---------- Clothing (newborn) ----------
    Product(id: '1', stock: 25, name: 'Organic Cotton Baby Onesie', category: 'Clothing', ageGroup: '0-6 Months', price: 16.00, sizes: [..._clothesSizes], rating: 4.8, reviewCount: 120, isBestSeller: true, description: 'Made from 100% organic cotton that is gentle on newborn skin. The envelope neckline and snap closures make changing quick. Machine washable and stays soft after many washes.'),
    Product(id: '2', stock: 25, name: 'Sleep Suit', category: 'Clothing', ageGroup: '0-6 Months', price: 22.50, sizes: [..._clothesSizes], rating: 4.6, reviewCount: 64, onSale: true, description: 'A cosy zip-up sleep suit with fold-over mitts to keep tiny hands warm. The two-way zip makes night-time changes easy.'),
    Product(id: '3', stock: 25, name: 'Cotton Onesie', category: 'Clothing', ageGroup: '0-6 Months', price: 14.99, sizes: [..._clothesSizes], rating: 4.7, reviewCount: 98, isBestSeller: true, description: 'An everyday short-sleeve onesie in breathable cotton. Buy a few so there is always a clean one ready.'),
    Product(id: '4', stock: 25, name: 'Newborn Swaddle Blanket', category: 'Clothing', ageGroup: '0-6 Months', price: 17.50, rating: 4.8, reviewCount: 71, isBestSeller: true, description: 'A large muslin swaddle that keeps your baby snug and calm. Light and breathable, and it also works as a pram cover.'),
    Product(id: '5', stock: 25, name: 'Mittens and Cap Set', category: 'Clothing', ageGroup: '0-6 Months', price: 8.99, sizes: ['0-3M', '3-6M'], rating: 4.4, reviewCount: 36, onSale: true, description: 'A soft stretch cap with matching mittens to protect against cold and scratches.'),
    // ---------- Clothing (toddler) and Feeding ----------
    Product(id: '6', stock: 25, name: 'Knit Romper', category: 'Clothing', ageGroup: '6-12 Months', price: 18.99, sizes: [..._clothesSizes], rating: 4.5, reviewCount: 41, description: 'A warm knit romper with a soft lining. Easy snap fastening along the legs makes dressing simple.'),
    Product(id: '7', stock: 25, name: 'Cute Bib Set', category: 'Feeding', ageGroup: '6-12 Months', price: 12.00, rating: 4.4, reviewCount: 33, onSale: true, description: 'A set of three bibs with a waterproof back that wipe clean fast. The adjustable fastening grows with your baby.'),
    Product(id: '8', stock: 25, name: 'Denim Dungarees', category: 'Clothing', ageGroup: '6-12 Months', price: 24.00, sizes: [..._toddlerSizes], rating: 4.5, reviewCount: 27, description: 'Soft washed denim dungarees with adjustable straps and a stretch waist, made for crawling and playing.'),
    Product(id: '9', stock: 25, name: 'Cotton Pyjama Set', category: 'Clothing', ageGroup: '6-12 Months', price: 19.50, sizes: [..._toddlerSizes], rating: 4.7, reviewCount: 59, isBestSeller: true, description: 'Two-piece cotton pyjamas in playful prints. Breathable fabric so your little one sleeps comfortably all night.'),
    Product(id: '10', stock: 25, name: 'Hooded Bath Towel', category: 'Clothing', ageGroup: '6-12 Months', price: 13.00, rating: 4.6, reviewCount: 45, description: 'An extra-soft hooded towel that keeps your baby warm after bath time. Quick drying and gentle on the skin.'),
    // ---------- Toys ----------
    Product(id: '11', stock: 25, name: 'Soft Plush Bear', category: 'Toys', ageGroup: '0-6 Months', price: 11.50, rating: 4.9, reviewCount: 77, isBestSeller: true, description: 'A super soft bear for cuddles and comfort. Safe for newborns and machine washable.'),
    Product(id: '12', stock: 25, name: 'Wooden Stacking Blocks', category: 'Toys', ageGroup: '6-12 Months', price: 15.00, rating: 4.6, reviewCount: 52, description: 'Colourful wooden blocks that build hand-eye coordination. Smooth edges and non-toxic paint.'),
    Product(id: '13', stock: 25, name: 'Baby Rattle Set', category: 'Toys', ageGroup: '0-6 Months', price: 7.99, rating: 4.5, reviewCount: 66, onSale: true, description: 'A set of four light rattles that are easy for small hands to grip and shake.'),
    Product(id: '14', stock: 25, name: 'Musical Activity Cube', category: 'Toys', ageGroup: '6-12 Months', price: 26.00, rating: 4.7, reviewCount: 38, description: 'An activity cube with lights, sounds and moving parts that keeps babies curious and entertained.'),
    Product(id: '15', stock: 25, name: 'Teething Ring Set', category: 'Toys', ageGroup: '0-6 Months', price: 6.50, rating: 4.5, reviewCount: 82, isBestSeller: true, description: 'BPA-free silicone teething rings that soothe sore gums. Freezer safe and easy to clean.'),
    // ---------- Clothing: Footwear ----------
    Product(id: '16', stock: 25, name: 'Soft Sole Leather Booties', category: 'Clothing', subCategory: 'Footwear', ageGroup: '6-12 Months', price: 13.50, sizes: ['0-6M', '6-12M', '12-18M'], rating: 4.3, reviewCount: 29, description: 'Genuine soft leather booties with elastic ankles that stay on moving feet.'),
    Product(id: '17', stock: 25, name: 'Baby Booties', category: 'Clothing', subCategory: 'Footwear', ageGroup: '0-6 Months', price: 9.99, sizes: ['0-6M', '6-12M'], rating: 4.5, reviewCount: 58, isBestSeller: true, onSale: true, description: 'Knitted booties that keep little feet warm. Stretch cuffs help them stay in place.'),
    Product(id: '18', stock: 25, name: 'Toddler Sandals', category: 'Clothing', subCategory: 'Footwear', ageGroup: '6-12 Months', price: 16.50, sizes: [..._shoeSizes], rating: 4.2, reviewCount: 21, description: 'Lightweight sandals with hook-and-loop straps and flexible soles for first steps.'),
    Product(id: '19', stock: 25, name: 'First Walker Sneakers', category: 'Clothing', subCategory: 'Footwear', ageGroup: '6-12 Months', price: 21.00, sizes: [..._shoeSizes], rating: 4.6, reviewCount: 34, isBestSeller: true, onSale: true, description: 'Flexible, cushioned sneakers made to support early walking, with a wide opening for easy fitting.'),
    // ---------- Diapers ----------
    Product(id: '20', stock: 25, name: 'Newborn Diapers 40 Pack', category: 'Diapers', ageGroup: '0-6 Months', price: 12.99, sizes: ['Newborn'], rating: 4.7, reviewCount: 142, isBestSeller: true, description: 'Soft, ultra-absorbent diapers with a wetness indicator and a cut-out for the umbilical cord. Up to 12 hours of dry protection.'),
    Product(id: '21', stock: 25, name: 'Size 1 Diapers 50 Pack', category: 'Diapers', ageGroup: '0-6 Months', price: 14.50, sizes: ['Size 1'], rating: 4.6, reviewCount: 96, onSale: true, description: 'Breathable stretch sides give a snug fit and leak guards keep nights dry.'),
    Product(id: '22', stock: 25, name: 'Size 2 Diapers 56 Pack', category: 'Diapers', ageGroup: '6-12 Months', price: 15.99, sizes: ['Size 2'], rating: 4.6, reviewCount: 88, description: 'An absorbent core and soft cover for active babies who crawl and roll.'),
    Product(id: '23', stock: 25, name: 'Gentle Baby Wipes 3 Pack', category: 'Diapers', ageGroup: '0-6 Months', price: 7.50, rating: 4.8, reviewCount: 115, isBestSeller: true, description: 'Fragrance-free wipes with aloe, mild enough for newborn skin. Pack of three.'),
    Product(id: '24', stock: 25, name: 'Reusable Cloth Diaper Set', category: 'Diapers', ageGroup: '6-12 Months', price: 19.00, sizes: ['One size'], rating: 4.4, reviewCount: 31, onSale: true, description: 'Washable cloth diapers with adjustable snaps that grow with your baby. Includes three absorbent inserts.'),
    // ---------- Feeding ----------
    Product(id: '25', stock: 25, name: 'Anti-Colic Feeding Bottle 240ml', category: 'Feeding', ageGroup: '0-6 Months', price: 10.99, rating: 4.7, reviewCount: 103, isBestSeller: true, description: 'A vented bottle that reduces gas and colic. BPA-free with a soft slow-flow nipple.'),
    Product(id: '26', stock: 25, name: 'Silicone Feeding Set', category: 'Feeding', ageGroup: '6-12 Months', price: 14.00, rating: 4.6, reviewCount: 57, description: 'A suction bowl, soft spoon and bib in one set. Dishwasher safe.'),
    Product(id: '27', stock: 25, name: 'Sippy Cup with Handles', category: 'Feeding', ageGroup: '6-12 Months', price: 8.99, rating: 4.4, reviewCount: 40, onSale: true, description: 'A spill-proof cup with easy-grip handles for learning to drink.'),
    Product(id: '28', stock: 25, name: 'Baby Food Spoon Set', category: 'Feeding', ageGroup: '6-12 Months', price: 5.99, rating: 4.5, reviewCount: 47, description: 'Soft-tip spoons that are gentle on gums. Pack of four.'),
    Product(id: '29', stock: 25, name: 'Milk Powder Dispenser', category: 'Feeding', ageGroup: '0-6 Months', price: 9.50, rating: 4.3, reviewCount: 22, description: 'A three-compartment dispenser for quick, tidy night-time feeds.'),
  ];

  static final List<Review> reviews = [
    const Review(id: '1', productId: '1', userId: '1', userName: 'You', rating: 5, comment: 'Super soft fabric and fits my 4-month-old perfectly! Highly recommend.'),
    const Review(id: '2', productId: '16', userId: '1', userName: 'You', rating: 4, comment: 'Great quality, but size runs slightly large. Keeps baby warm though.'),
    const Review(id: '3', productId: '1', userId: '2', userName: 'Amaka', rating: 5, comment: 'Washed it ten times and it still feels brand new.'),
    const Review(id: '4', productId: '1', userId: '3', userName: 'Tunde', rating: 4, comment: 'Good quality. I wish it came in more colours.'),
    const Review(id: '5', productId: '9', userId: '2', userName: 'Amaka', rating: 5, comment: 'My toddler sleeps so comfortably in these.'),
    const Review(id: '6', productId: '11', userId: '3', userName: 'Tunde', rating: 5, comment: 'My daughter takes it everywhere.'),
    const Review(id: '7', productId: '4', userId: '4', userName: 'Chioma', rating: 5, comment: 'Perfect for swaddling and as a light pram cover.'),
    const Review(id: '8', productId: '17', userId: '4', userName: 'Chioma', rating: 4, comment: 'Warm and cute, but they slip off if too big.'),
  ];

  /// At most 8, so the Home grid always fills whole rows.
  static List<Product> bestSellers() =>
      products.where((p) => p.isBestSeller).take(8).toList();

  static Product? byId(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Newest review first.
  static List<Review> reviewsForProduct(String productId) =>
      reviews.where((r) => r.productId == productId).toList().reversed.toList();

  static List<Review> reviewsForUser(String userId) =>
      reviews.where((r) => r.userId == userId).toList().reversed.toList();

  /// The single place a new review is saved. Also updates the product's average rating.
  static void addReview(Review r) {
    reviews.add(r);
    final p = byId(r.productId);
    if (p != null) {
      p.rating = (p.rating * p.reviewCount + r.rating) / (p.reviewCount + 1);
      p.reviewCount += 1;
    }
  }
}
