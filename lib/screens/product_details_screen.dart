import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_bridge.dart';
import '../services/product_service.dart';
import '../utils/browse_colors.dart';
import '../widgets/product_image.dart';
import '../widgets/write_review_sheet.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _sizeIndex = 0;
  int _qty = 1;
  bool _liked = false;

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 22, bottom: 10),
        child: Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      );

  Widget _stars(int rating, double size) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (s) => Icon(s < rating ? Icons.star : Icons.star_border, color: BrowseColors.amber, size: size),
        ),
      );

  Widget _reviewTile(Review r) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BrowseColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(r.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                _stars(r.rating, 16),
              ],
            ),
            if (r.comment.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(r.comment, style: const TextStyle(color: Colors.black87)),
            ],
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final reviews = ProductService.reviewsForProduct(p.id);
    return Scaffold(
      backgroundColor: BrowseColors.bg,
      appBar: AppBar(
        backgroundColor: BrowseColors.bg,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () => setState(() => _liked = !_liked),
            icon: Icon(_liked ? Icons.favorite : Icons.favorite_border, color: _liked ? Colors.red : Colors.black87),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ProductImage(imagePath: p.image, height: 280),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(p.name, style: const TextStyle(fontSize: 22))),
              const SizedBox(width: 12),
              Text(p.priceText, style: const TextStyle(fontSize: 22, color: BrowseColors.green, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Text('★ ${p.rating.toStringAsFixed(1)} (${p.reviewCount} reviews)', style: const TextStyle(color: BrowseColors.amber)),
          if (p.sizes.isNotEmpty) ...[
            _label('Select Size'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var i = 0; i < p.sizes.length; i++)
                  GestureDetector(
                    onTap: () => setState(() => _sizeIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                      decoration: BoxDecoration(
                        color: i == _sizeIndex ? BrowseColors.lightBlue : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: i == _sizeIndex ? BrowseColors.blue : BrowseColors.border,
                          width: i == _sizeIndex ? 1.5 : 1,
                        ),
                      ),
                      child: Text(p.sizes[i], style: TextStyle(color: i == _sizeIndex ? BrowseColors.blue : Colors.black87)),
                    ),
                  ),
              ],
            ),
          ],
          _label('Quantity'),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: BrowseColors.grey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: BrowseColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                    icon: const Icon(Icons.remove),
                  ),
                  SizedBox(width: 36, child: Center(child: Text('$_qty', style: const TextStyle(fontSize: 16)))),
                  IconButton(
                    onPressed: () => setState(() => _qty++),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
          if (p.description.isNotEmpty) ...[
            _label('Product Details'),
            Text(p.description, style: const TextStyle(color: Colors.black87, height: 1.4)),
          ],
          _label('Customer Reviews'),
          Row(
            children: [
              Text(p.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: BrowseColors.amber)),
              const SizedBox(width: 8),
              _stars(p.rating.round(), 20),
              const SizedBox(width: 8),
              Text('(${p.reviewCount})', style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 12),
          if (reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('No reviews yet. Be the first to review this product.', style: TextStyle(color: Colors.black54)),
            )
          else
            for (final r in reviews.take(3)) _reviewTile(r),
          OutlinedButton.icon(
            onPressed: () async {
              final saved = await showWriteReviewSheet(context, product: p);
              if (saved == true && mounted) setState(() {});
            },
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text('Write a review'),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: BrowseColors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => addToCart(
                context,
                p,
                size: p.sizes.isEmpty ? null : p.sizes[_sizeIndex],
                qty: _qty,
              ),
              child: const Text('Add to Cart', style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ),
    );
  }
}
