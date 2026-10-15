import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../utils/browse_colors.dart';
import '../widgets/product_image.dart';

class MyReviewsScreen extends StatelessWidget {
  /// Zizi: pass the logged-in user's id from the Profile screen.
  final String? userId;

  const MyReviewsScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final reviews = ProductService.reviewsForUser(userId ?? ProductService.currentUserId);
    return Scaffold(
      backgroundColor: BrowseColors.bg,
      appBar: AppBar(
        backgroundColor: BrowseColors.bg,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('My Reviews'),
      ),
      body: reviews.isEmpty
          ? const Center(child: Text('No reviews yet. Review a product you have bought.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final r = reviews[i];
                final p = ProductService.byId(r.productId);
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: BrowseColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 64, height: 64, child: ProductImage(imagePath: p?.image)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p?.name ?? 'Product', style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 6),
                                Row(
                                  children: List.generate(
                                    5,
                                    (s) => Icon(
                                      s < r.rating ? Icons.star : Icons.star_border,
                                      color: BrowseColors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (r.comment.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(r.comment, style: const TextStyle(color: Colors.black87)),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
