import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'product_model.dart';
import 'category_model.dart';
import 'cart_provider.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _timer;
  int _currentBannerIndex = 0;

  List<String> banners = [
    'https://picsum.photos/id/1/1200/400',
    'https://picsum.photos/id/2/1200/400',
    'https://picsum.photos/id/3/1200/400',
    'https://picsum.photos/id/4/1200/400',
  ];

  List<Category> categories = [
    Category(name: 'Điện thoại', icon: Icons.phone_android),
    Category(name: 'Laptop', icon: Icons.laptop),
    Category(name: 'Máy tính bảng', icon: Icons.tablet_android),
    Category(name: 'Phụ kiện', icon: Icons.watch),
    Category(name: 'Âm thanh', icon: Icons.headset),
    Category(name: 'Gaming', icon: Icons.videogame_asset),
  ];

  final List<Product> _allProducts = [
    Product(id: 'p1', name: 'iPhone 15', imageUrl: 'https://picsum.photos/seed/iphone15/300/450', tag: 'New', price: 999.99, sold: 2500, category: 'Electronics'),
    Product(id: 'p2', name: 'Nike Air Max', imageUrl: 'https://picsum.photos/seed/nikeairmax/300/450', tag: 'Trending', price: 129.99, sold: 1800, category: 'Clothing'),
    Product(id: 'p3', name: 'Samsung TV 55"', imageUrl: 'https://picsum.photos/seed/samsungtv/300/450', tag: 'Sale', price: 699.99, sold: 1200, category: 'Electronics'),
    Product(id: 'p4', name: 'Levi\'s Jeans', imageUrl: 'https://picsum.photos/seed/levisjeans/300/450', tag: 'Popular', price: 79.99, sold: 3000, category: 'Clothing'),
    Product(id: 'p5', name: 'Kitchen Blender', imageUrl: 'https://picsum.photos/seed/blender/300/450', tag: 'New', price: 149.99, sold: 800, category: 'Home'),
    Product(id: 'p6', name: 'Harry Potter Book Set', imageUrl: 'https://picsum.photos/seed/harrypotter/300/450', tag: 'Bestseller', price: 89.99, sold: 1500, category: 'Books'),
    Product(id: 'p7', name: 'Yoga Mat', imageUrl: 'https://picsum.photos/seed/yogamat/300/450', tag: 'Fitness', price: 39.99, sold: 2200, category: 'Sports'),
    Product(id: 'p8', name: 'Skincare Set', imageUrl: 'https://picsum.photos/seed/skincare/300/450', tag: 'Beauty', price: 59.99, sold: 1900, category: 'Beauty'),
    Product(id: 'p9', name: 'Coffee Maker', imageUrl: 'https://picsum.photos/seed/coffeemaker/300/450', tag: 'Home', price: 199.99, sold: 1100, category: 'Home'),
    Product(id: 'p10', name: 'Wireless Headphones', imageUrl: 'https://picsum.photos/seed/headphones/300/450', tag: 'Top Rated', price: 249.99, sold: 3200, category: 'Electronics'),
    Product(id: 'p11', name: 'Gaming Mouse', imageUrl: 'https://picsum.photos/seed/gamingmouse/300/450', tag: 'New', price: 49.99, sold: 2800, category: 'Electronics'),
    Product(id: 'p12', name: 'Running Shoes', imageUrl: 'https://picsum.photos/seed/runningshoes/300/450', tag: 'Trending', price: 89.99, sold: 2500, category: 'Sports'),
    Product(id: 'p13', name: 'Cookbook', imageUrl: 'https://picsum.photos/seed/cookbook/300/450', tag: 'Bestseller', price: 29.99, sold: 1800, category: 'Books'),
    Product(id: 'p14', name: 'Smartwatch', imageUrl: 'https://picsum.photos/seed/smartwatch/300/450', tag: 'Top Rated', price: 299.99, sold: 2100, category: 'Electronics'),
    Product(id: 'p15', name: 'Laptop Stand', imageUrl: 'https://picsum.photos/seed/laptopstand/300/450', tag: 'New', price: 39.99, sold: 1500, category: 'Home'),
    Product(id: 'p16', name: 'Protein Powder', imageUrl: 'https://picsum.photos/seed/proteinpowder/300/450', tag: 'Fitness', price: 49.99, sold: 3200, category: 'Sports'),
    Product(id: 'p17', name: 'Makeup Kit', imageUrl: 'https://picsum.photos/seed/makeupkit/300/450', tag: 'Beauty', price: 79.99, sold: 2400, category: 'Beauty'),
    Product(id: 'p18', name: 'Bluetooth Speaker', imageUrl: 'https://picsum.photos/seed/bluetoothspeaker/300/450', tag: 'Top Rated', price: 99.99, sold: 1900, category: 'Electronics'),
    Product(id: 'p19', name: 'T-shirt Pack', imageUrl: 'https://picsum.photos/seed/tshirtpack/300/450', tag: 'New', price: 29.99, sold: 3500, category: 'Clothing'),
    Product(id: 'p20', name: 'Perfume', imageUrl: 'https://picsum.photos/seed/perfume/300/450', tag: 'Trending', price: 69.99, sold: 2200, category: 'Beauty'),
  ];

  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
    _startBannerTimer();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _startBannerTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (mounted) {
        if (_currentBannerIndex < banners.length - 1) {
          _currentBannerIndex++;
        } else {
          _currentBannerIndex = 0;
        }
        _pageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 145.0, // Tăng chiều cao để thoáng hơn
            backgroundColor: _scrollController.hasClients && _scrollController.offset > 50 ? Colors.orange : Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(top: 85.0, left: 16.0, right: 16.0, bottom: 10), // Đẩy thanh search xuống thấp hơn
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterProducts, // Gọi hàm lọc khi nhập chữ
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      suffixIcon: _searchController.text.isNotEmpty 
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white),
                            onPressed: () {
                              _searchController.clear();
                              _filterProducts('');
                            },
                          )
                        : null,
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
                      hintStyle: const TextStyle(color: Colors.white70),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            title: const Text('TECH STORE', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
            actions: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartScreen())),
                  ),
                  if (cart.items.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text('${cart.items.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_searchController.text.isEmpty) ...[
                  // Banner chỉ hiện khi không tìm kiếm
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: banners.length,
                      onPageChanged: (index) => setState(() => _currentBannerIndex = index),
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(banners[index], fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      banners.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: _currentBannerIndex == index ? 20.0 : 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentBannerIndex == index ? Colors.orange : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  // Categories
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Text('Danh mục', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Container(
                          width: 85,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey[900],
                                child: Icon(category.icon, color: Colors.orange, size: 28),
                              ),
                              const SizedBox(height: 8),
                              Text(category.name, style: const TextStyle(fontSize: 11, color: Colors.white70), textAlign: TextAlign.center),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
                // Products Grid
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Text(
                    _searchController.text.isEmpty ? 'Gợi ý cho bạn' : 'Kết quả tìm kiếm (${_filteredProducts.length})', 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                ),
                if (_filteredProducts.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text('Không tìm thấy sản phẩm nào!', style: TextStyle(color: Colors.white60)),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return _buildProductCard(context, product, cart);
                    },
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, CartProvider cart) {
    return Card(
      color: Colors.grey[900],
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Image.network(product.imageUrl, fit: BoxFit.cover, width: double.infinity),
                if (product.tag.isNotEmpty)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                      child: Text(product.tag, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${product.price}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Bán ${product.sold}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      cart.addToCart(product);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã thêm ${product.name} vào giỏ'),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      foregroundColor: Colors.orange,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.orange, width: 0.5)),
                    ),
                    child: const Text('Thêm vào giỏ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
