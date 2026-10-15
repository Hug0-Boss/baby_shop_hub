import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../utils/browse_colors.dart';
import '../widgets/product_card.dart';

class ProductListingScreen extends StatefulWidget {
  final String? category; // null = all products
  final String? query; // search text from the Home search bar

  const ProductListingScreen({super.key, this.category, this.query});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  static const _baseFilters = ['All', '0-6 Months', '6-12 Months', 'On Sale'];

  /// Footwear lives under Clothing, so the Footwear chip shows there (and on All Products).
  List<String> get _filters => [
        ..._baseFilters,
        if (widget.category == null || widget.category == 'Clothing') 'Footwear',
      ];

  String _filter = 'All';
  bool _cheapestFirst = false;

  List<Product> get _items {
    final list = ProductService.products.where((p) {
      if (widget.category != null && p.category != widget.category) return false;
      final q = widget.query?.trim().toLowerCase() ?? '';
      if (q.isNotEmpty && !p.name.toLowerCase().contains(q)) return false;
      if (_filter == 'On Sale') return p.onSale;
      if (_filter == 'Footwear') return p.subCategory == 'Footwear';
      if (_filter != 'All') return p.ageGroup == _filter;
      return true;
    }).toList();
    if (_cheapestFirst) list.sort((a, b) => a.price.compareTo(b.price));
    return list;
  }

  String get _title {
    if (widget.category != null) return widget.category!;
    if (widget.query != null && widget.query!.trim().isNotEmpty) return 'Results for "${widget.query!.trim()}"';
    return 'All Products';
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return Scaffold(
      backgroundColor: BrowseColors.bg,
      appBar: AppBar(
        backgroundColor: BrowseColors.bg,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(_title),
        actions: [
          TextButton(
            onPressed: () => setState(() => _cheapestFirst = !_cheapestFirst),
            child: Text(_cheapestFirst ? 'Cheapest first' : 'Sort by price'),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final selected = _filters[i] == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = _filters[i]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? BrowseColors.blue : BrowseColors.grey,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? BrowseColors.blue : BrowseColors.border),
                    ),
                    child: Text(_filters[i], style: TextStyle(color: selected ? Colors.white : Colors.black87)),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No products match. Try another filter.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (_, i) => ProductCard(product: items[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
