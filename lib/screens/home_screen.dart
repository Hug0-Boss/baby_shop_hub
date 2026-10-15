import 'dart:async';
import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../utils/browse_colors.dart';
import '../widgets/product_card.dart';
import 'product_listing_screen.dart';

/// One discount offer in the auto-rotating banner.
class _Offer {
  final String tag, title, sub, category, image;
  final Color bg, line, text;
  const _Offer(
    this.tag,
    this.title,
    this.sub,
    this.category,
    this.image,
    this.bg,
    this.line,
    this.text,
  );
}

const _offers = [
  _Offer(
    'BABY ESSENTIALS',
    'Up to 30% Off',
    'Clothing and footwear',
    'Clothing',
    'assets/images/banners/clothing.jpg',
    Color(0xFFFCE7F3),
    Color(0xFFF472B6),
    Color(0xFF831843),
  ),
  _Offer(
    'STOCK UP AND SAVE',
    'Up to 25% Off',
    'Diapers and wipes',
    'Diapers',
    'assets/images/banners/diapers.jpg',
    Color(0xFFE0F2FE),
    Color(0xFF38BDF8),
    Color(0xFF075985),
  ),
  _Offer(
    'PLAYTIME SALE',
    '20% Off Toys',
    'Soft and safe toys',
    'Toys',
    'assets/images/banners/toys.jpg',
    Color(0xFFFEF3C7),
    Color(0xFFFBBF24),
    Color(0xFF78350F),
  ),
  _Offer(
    'MEAL TIME',
    'As low as \$5.99',
    'Bottles, bibs and more',
    'Feeding',
    'assets/images/banners/feeding.jpg',
    Color(0xFFDCFCE7),
    Color(0xFF4ADE80),
    Color(0xFF14532D),
  ),
];

const _categoryIcons = <String, IconData>{
  'Clothing': Icons.checkroom,
  'Diapers': Icons.baby_changing_station,
  'Toys': Icons.toys,
  'Feeding': Icons.restaurant,
};

const _categoryBackgrounds = <String, Color>{
  'Clothing': Color.fromARGB(255, 250, 171, 207),
  'Diapers': Color.fromARGB(255, 94, 207, 220),
  'Toys': Color.fromARGB(255, 251, 239, 196),
  'Feeding': Color.fromARGB(255, 184, 253, 203),
};

class HomeScreen extends StatefulWidget {
  /// Zizi: pass the logged-in user's name here after login.
  final String userName;

  const HomeScreen({super.key, this.userName = 'Shopper'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    // Slide to the next offer every 4 seconds.
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      _pageController.animateToPage(
        (_page + 1) % _offers.length,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _open(Widget screen) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));

  void _soon(String name) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('$name is a teammate\'s screen')));

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 12),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrowseColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: BrowseColors.grey,
                  child: Icon(Icons.person, color: BrowseColors.mutedText),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Hello, ${widget.userName}!',
                    style: const TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _soon('Cart'),
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: BrowseColors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (q) => _open(ProductListingScreen(query: q)),
              decoration: InputDecoration(
                hintText: 'Search on BabyShopHub',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color.fromARGB(255, 254, 254, 247),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: BrowseColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Colors.blueGrey.shade100,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(
                    color: Color(0xFF1E3A8A),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _offers.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final o = _offers[i];
                  return GestureDetector(
                    onTap: () =>
                        _open(ProductListingScreen(category: o.category)),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: o.bg,
                        border: Border.all(color: o.line),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  o.tag,
                                  style: TextStyle(
                                    color: o.text,
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  o.title,
                                  style: TextStyle(
                                    color: o.text,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  o.sub,
                                  style: TextStyle(color: o.text, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 90,
                            height: 90,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              o.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Icon(Icons.image_outlined, color: o.text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _offers.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: i == _page ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: i == _page ? _offers[i].line : BrowseColors.border,
                  ),
                ),
              ),
            ),
            _sectionTitle('Categories'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ProductService.categories
                  .map(
                    (c) => GestureDetector(
                      onTap: () => _open(ProductListingScreen(category: c)),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color:
                                  _categoryBackgrounds[c] ??
                                  BrowseColors.lightBlue,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: BrowseColors.lightBlueBorder,
                              ),
                            ),
                            child: Icon(
                              _categoryIcons[c],
                              color: BrowseColors.blue,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(c, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            Row(
              children: [
                Expanded(child: _sectionTitle('Best Sellers')),
                TextButton(
                  onPressed: () => _open(const ProductListingScreen()),
                  child: const Text('See All'),
                ),
              ],
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
              children: ProductService.bestSellers()
                  .map((p) => ProductCard(product: p, showAdd: true))
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,    // Change unselected icon/text color here
        backgroundColor: Color.fromARGB(255, 239, 247, 255),
        onDestinationSelected: (i) {
          if (i == 1) {
            _open(const ProductListingScreen());
          } else if (i == 2) {
            _soon('Cart');
          } else if (i == 3) {
            _soon('Profile');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'Catalog'),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
