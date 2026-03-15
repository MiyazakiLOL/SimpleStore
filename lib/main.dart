import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ProductWebApp());
}

class Product {
  final String name;
  final String imageUrl;
  final String tag;
  final double price;
  final int sold;
  final String category;

  Product({
    required this.name,
    required this.imageUrl,
    required this.tag,
    required this.price,
    required this.sold,
    required this.category,
  });
}

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}

class ProductWebApp extends StatelessWidget {
  const ProductWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Store',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentBannerIndex = 0;
  int _watchlistCount = 5; // Giả sử có 5 phim trong watchlist
  int _cartCount = 3; // Giả sử có 3 sản phẩm trong giỏ

  List<String> banners = [
    'https://picsum.photos/seed/movieCover/1200/400',
    'https://picsum.photos/seed/movie2/1200/400',
    'https://picsum.photos/seed/movie3/1200/400',
    'https://picsum.photos/seed/movie4/1200/400',
  ];

  List<Category> categories = [
    Category(name: 'Electronics', icon: Icons.devices),
    Category(name: 'Clothing', icon: Icons.checkroom),
    Category(name: 'Home', icon: Icons.home),
    Category(name: 'Books', icon: Icons.book),
    Category(name: 'Sports', icon: Icons.sports_soccer),
    Category(name: 'Beauty', icon: Icons.face),
  ];

  List<Product> products = [
    Product(
      name: 'iPhone 15',
      imageUrl: 'https://picsum.photos/seed/iphone15/300/450',
      tag: 'New',
      price: 999.99,
      sold: 2500,
      category: 'Electronics',
    ),
    Product(
      name: 'Nike Air Max',
      imageUrl: 'https://picsum.photos/seed/nikeairmax/300/450',
      tag: 'Trending',
      price: 129.99,
      sold: 1800,
      category: 'Clothing',
    ),
    Product(
      name: 'Samsung TV 55"',
      imageUrl: 'https://picsum.photos/seed/samsungtv/300/450',
      tag: 'Sale',
      price: 699.99,
      sold: 1200,
      category: 'Electronics',
    ),
    Product(
      name: 'Levi\'s Jeans',
      imageUrl: 'https://picsum.photos/seed/levisjeans/300/450',
      tag: 'Popular',
      price: 79.99,
      sold: 3000,
      category: 'Clothing',
    ),
    Product(
      name: 'Kitchen Blender',
      imageUrl: 'https://picsum.photos/seed/blender/300/450',
      tag: 'New',
      price: 149.99,
      sold: 800,
      category: 'Home',
    ),
    Product(
      name: 'Harry Potter Book Set',
      imageUrl: 'https://picsum.photos/seed/harrypotter/300/450',
      tag: 'Bestseller',
      price: 89.99,
      sold: 1500,
      category: 'Books',
    ),
    Product(
      name: 'Yoga Mat',
      imageUrl: 'https://picsum.photos/seed/yogamat/300/450',
      tag: 'Fitness',
      price: 39.99,
      sold: 2200,
      category: 'Sports',
    ),
    Product(
      name: 'Skincare Set',
      imageUrl: 'https://picsum.photos/seed/skincare/300/450',
      tag: 'Beauty',
      price: 59.99,
      sold: 1900,
      category: 'Beauty',
    ),
    Product(
      name: 'Coffee Maker',
      imageUrl: 'https://picsum.photos/seed/coffeemaker/300/450',
      tag: 'Home',
      price: 199.99,
      sold: 1100,
      category: 'Home',
    ),
    Product(
      name: 'Wireless Headphones',
      imageUrl: 'https://picsum.photos/seed/headphones/300/450',
      tag: 'Top Rated',
      price: 249.99,
      sold: 3200,
      category: 'Electronics',
    ),
    Product(
      name: 'Gaming Mouse',
      imageUrl: 'https://picsum.photos/seed/gamingmouse/300/450',
      tag: 'New',
      price: 49.99,
      sold: 2800,
      category: 'Electronics',
    ),
    Product(
      name: 'Running Shoes',
      imageUrl: 'https://picsum.photos/seed/runningshoes/300/450',
      tag: 'Trending',
      price: 89.99,
      sold: 2500,
      category: 'Sports',
    ),
    Product(
      name: 'Cookbook',
      imageUrl: 'https://picsum.photos/seed/cookbook/300/450',
      tag: 'Bestseller',
      price: 29.99,
      sold: 1800,
      category: 'Books',
    ),
    Product(
      name: 'Smartwatch',
      imageUrl: 'https://picsum.photos/seed/smartwatch/300/450',
      tag: 'Top Rated',
      price: 299.99,
      sold: 2100,
      category: 'Electronics',
    ),
    Product(
      name: 'Laptop Stand',
      imageUrl: 'https://picsum.photos/seed/laptopstand/300/450',
      tag: 'New',
      price: 39.99,
      sold: 1500,
      category: 'Home',
    ),
    Product(
      name: 'Protein Powder',
      imageUrl: 'https://picsum.photos/seed/proteinpowder/300/450',
      tag: 'Fitness',
      price: 49.99,
      sold: 3200,
      category: 'Sports',
    ),
    Product(
      name: 'Makeup Kit',
      imageUrl: 'https://picsum.photos/seed/makeupkit/300/450',
      tag: 'Beauty',
      price: 79.99,
      sold: 2400,
      category: 'Beauty',
    ),
    Product(
      name: 'Bluetooth Speaker',
      imageUrl: 'https://picsum.photos/seed/bluetoothspeaker/300/450',
      tag: 'Top Rated',
      price: 99.99,
      sold: 1900,
      category: 'Electronics',
    ),
    Product(
      name: 'T-shirt Pack',
      imageUrl: 'https://picsum.photos/seed/tshirtpack/300/450',
      tag: 'New',
      price: 29.99,
      sold: 3500,
      category: 'Clothing',
    ),
    Product(
      name: 'Perfume',
      imageUrl: 'https://picsum.photos/seed/perfume/300/450',
      tag: 'Trending',
      price: 69.99,
      sold: 2200,
      category: 'Beauty',
    ),
  ];

  bool _isLoading = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _startBannerTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      setState(() {
        if (_currentBannerIndex < banners.length - 1) {
          _currentBannerIndex++;
        } else {
          _currentBannerIndex = 0;
        }
      });
      _pageController.animateToPage(
        _currentBannerIndex,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _refreshProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      products = [
        Product(
          name: 'Refreshed iPhone',
          imageUrl: 'https://picsum.photos/seed/refreshed1/300/450',
          tag: 'New',
          price: 999.99,
          sold: 2000,
          category: 'Electronics',
        ),
        Product(
          name: 'Refreshed Sneakers',
          imageUrl: 'https://picsum.photos/seed/refreshed2/300/450',
          tag: 'New',
          price: 129.99,
          sold: 1800,
          category: 'Clothing',
        ),
        // Add more as needed
      ];
      _currentPage = 1;
    });
  }

  void _loadMoreProducts() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      products.addAll([
        Product(
          name: 'Loaded iPhone',
          imageUrl: 'https://picsum.photos/seed/loaded1/300/450',
          tag: 'More',
          price: 899.99,
          sold: 500,
          category: 'Electronics',
        ),
        Product(
          name: 'Loaded Sneakers',
          imageUrl: 'https://picsum.photos/seed/loaded2/300/450',
          tag: 'More',
          price: 119.99,
          sold: 300,
          category: 'Clothing',
        ),
        // Add more as needed
      ]);
      _currentPage++;
      _isLoading = false;
    });
  }

  void _filterByCategory(String category) {
    // Implement filtering logic here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Filtering by $category')));
  }

  String _formatSold(int sold) {
    if (sold >= 1000) {
      return '${(sold / 1000).toStringAsFixed(1)}k';
    }
    return sold.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120.0,
            backgroundColor:
                _scrollController.hasClients && _scrollController.offset > 50
                ? Colors.red
                : Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 60.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: const TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            title: const Text(
              'Product Store',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      // Navigate to cart
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: _refreshProducts,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Carousel
                  SizedBox(
                    height: 400,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: banners.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentBannerIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(banners[index], fit: BoxFit.cover);
                      },
                    ),
                  ),
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      banners.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentBannerIndex == index
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Categories
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Categories',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 180,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () => _filterByCategory(category.name),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  category.icon,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                category.name,
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Featured Products
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Featured Products',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length.clamp(0, 8),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    product.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            color: Colors.grey[900],
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[900],
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.white38,
                                            size: 40,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Discover Products
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Discover Products',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= (products.length ~/ 2) - 1 && !_isLoading) {
                _loadMoreProducts();
              }
              final startIndex = index * 2;
              final endIndex = (startIndex + 2).clamp(0, products.length);
              final rowProducts = products.sublist(startIndex, endIndex);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: rowProducts.map((product) {
                    return Expanded(
                      child: Container(
                        height: 320,
                        margin: const EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12.0),
                                ),
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          color: Colors.grey[900],
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[900],
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.white38,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        product.tag,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${_formatSold(product.sold)} sold',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }, childCount: (products.length / 2).ceil()),
          ),
        ],
      ),
    );
  }
}
