import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_details_screen.dart';
import '../services/cart_bridge.dart';
import '../utils/browse_colors.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool showAdd; // the quick "+" button (Home only)

  const ProductCard({super.key, required this.product, this.showAdd = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BrowseColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ProductImage(imagePath: product.image)),
            const SizedBox(height: 8),
            Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(product.priceText, style: const TextStyle(color: BrowseColors.green, fontWeight: FontWeight.w600)),
                ),
                if (showAdd)
                  GestureDetector(
                    onTap: () => addToCart(
                      context,
                      product,
                      size: product.sizes.isNotEmpty ? product.sizes.first : null,
                    ),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: BrowseColors.blue,
                      child: Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
