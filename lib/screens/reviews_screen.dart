import 'package:flutter/material.dart';

const Color _navy = Color(0xFF1E2A5E);
const Color _pink = Color(0xFFEC4899);
const Color _star = Color(0xFFFBBF24);

// One review (sample data - replace with real data later)
class Review {
  final String title; // product name or store name
  final double rating; // 1 to 5
  final String comment;
  final String date;
  final IconData icon;

  const Review({
    required this.title,
    required this.rating,
    required this.comment,
    required this.date,
    required this.icon,
  });
}

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Review> _productReviews = [
    const Review(
      title: 'Pampers Premium Care',
      rating: 5.0,
      comment: "Great quality and keeps my baby's skin dry. Highly recommend!",
      date: 'Mar 16, 2025',
      icon: Icons.child_care,
    ),
    const Review(
      title: 'Baby Carrier',
      rating: 4.5,
      comment: 'Comfortable and easy to use. Excellent quality.',
      date: 'Mar 12, 2025',
      icon: Icons.child_friendly,
    ),
    const Review(
      title: 'Feeding Bottle',
      rating: 5.0,
      comment: 'Good quality and no leakage. My baby loves it!',
      date: 'Mar 3, 2025',
      icon: Icons.local_drink,
    ),
  ];

  final List<Review> _storeReviews = [
    const Review(
      title: 'BabyShopHub',
      rating: 5.0,
      comment: 'Fast delivery and great customer service. Will order again!',
      date: 'Mar 14, 2025',
      icon: Icons.storefront,
    ),
    const Review(
      title: 'BabyShopHub',
      rating: 4.5,
      comment: 'Good prices and my order came well packaged.',
      date: 'Mar 5, 2025',
      icon: Icons.storefront,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _today() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: _navy,
        title: const Text(
          'My Reviews',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: _navy,
          unselectedLabelColor: Colors.grey,
          indicatorColor: _pink,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Product Reviews'),
            Tab(text: 'Store Reviews'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _reviewList(_productReviews),
          _reviewList(_storeReviews),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openWriteSheet,
        backgroundColor: _pink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit),
        label: const Text('Write a Review'),
      ),
    );
  }

  Widget _reviewList(List<Review> reviews) {
    if (reviews.isEmpty) {
      return const Center(child: Text('No reviews yet'));
    }
    return ListView.builder(
      // Extra space at the bottom so the button doesn't cover the last review
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      itemCount: reviews.length,
      itemBuilder: (context, index) => _reviewCard(reviews[index]),
    );
  }

  // Row of 5 stars (supports half stars like 4.5)
  Widget _stars(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        IconData icon;
        if (rating >= i + 1) {
          icon = Icons.star;
        } else if (rating >= i + 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, color: _star, size: size);
      }),
    );
  }

  Widget _reviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product picture (icon for now - swap for Image.asset later)
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFCE7F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(review.icon, color: _pink, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: _navy),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _stars(review.rating),
                    const SizedBox(width: 6),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(review.comment, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 6),
                Text(
                  review.date,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // The pop-up where the user picks stars and writes a review
  void _openWriteSheet() {
    final isProduct = _tabController.index == 0;
    final nameController =
    TextEditingController(text: isProduct ? '' : 'BabyShopHub');
    final commentController = TextEditingController();
    double rating = 0;
    String? error;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                // Moves the sheet up when the keyboard opens
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isProduct ? 'Review a Product' : 'Review the Store',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: isProduct ? 'Product name' : 'Store name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your rating',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(5, (i) {
                        return GestureDetector(
                          onTap: () => setSheetState(() => rating = i + 1.0),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              i < rating ? Icons.star : Icons.star_border,
                              color: _star,
                              size: 38,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Write your review',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Make sure everything is filled in
                          if (rating == 0 ||
                              nameController.text.trim().isEmpty ||
                              commentController.text.trim().isEmpty) {
                            setSheetState(() => error =
                            'Please fill everything in and pick a star rating.');
                            return;
                          }

                          // Add the new review to the top of the list
                          setState(() {
                            final list =
                            isProduct ? _productReviews : _storeReviews;
                            list.insert(
                              0,
                              Review(
                                title: nameController.text.trim(),
                                rating: rating,
                                comment: commentController.text.trim(),
                                date: _today(),
                                icon: isProduct
                                    ? Icons.shopping_bag
                                    : Icons.storefront,
                              ),
                            );
                          });
                          Navigator.pop(sheetContext);
                        },
                        child: const Text(
                          'Submit Review',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}