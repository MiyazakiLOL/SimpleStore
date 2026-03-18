import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/order_model.dart';
import '../models/order_status.dart';
import '../providers/cart_provider.dart';
import '../providers/order_store.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import 'product_detail_screen.dart';

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
  String? _selectedCategory;

  // API & Pagination state
  final List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentLimit = 10;
  bool _hasMore = true;

  List<String> banners = [
    'https://picsum.photos/seed/banner1/1200/400',
    'https://picsum.photos/seed/banner2/1200/400',
    'https://picsum.photos/seed/banner3/1200/400',
    'https://picsum.photos/seed/banner4/1200/400',
  ];

  List<Category> categories = [
    Category(name: "electronics", icon: Icons.bolt),
    Category(name: "jewelery", icon: Icons.diamond),
    Category(name: "men's clothing", icon: Icons.checkroom),
    Category(name: "women's clothing", icon: Icons.woman),
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Initial load
    _startBannerTimer();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // --- API LOGIC ---

  Future<void> _fetchProducts({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (isRefresh) {
        _currentLimit = 10;
        _hasMore = true;
        _allProducts.clear();
      }
    });

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products?limit=$_currentLimit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Product> fetched = data.map((e) => Product.fromFakeStore(e)).toList();

        setState(() {
          _allProducts.clear();
          _allProducts.addAll(fetched);
          _applyFilters();
          if (fetched.length < _currentLimit) _hasMore = false;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchMoreProducts() async {
    if (_isLoadingMore || !_hasMore || _searchController.text.isNotEmpty || _selectedCategory != null) return;

    setState(() => _isLoadingMore = true);
    final nextLimit = _currentLimit + 6;

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products?limit=$nextLimit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Product> fetched = data.map((e) => Product.fromFakeStore(e)).toList();

        setState(() {
          if (fetched.length <= _allProducts.length) {
            _hasMore = false;
          } else {
            _allProducts.clear();
            _allProducts.addAll(fetched);
            _currentLimit = nextLimit;
            _applyFilters();
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading more: $e');
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _fetchMoreProducts();
    }
    setState(() {}); // Update AppBar color on scroll
  }

  // --- FILTER LOGIC ---

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    _filteredProducts = _allProducts.where((product) {
      final matchesQuery = product.name.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == null || product.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  void _filterProducts(String query) {
    setState(() => _applyFilters());
  }

  void _selectCategory(String? categoryName) {
    setState(() {
      if (_selectedCategory == categoryName) {
        _selectedCategory = null;
      } else {
        _selectedCategory = categoryName;
      }
      _applyFilters();
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
      body: RefreshIndicator(
        onRefresh: () => _fetchProducts(isRefresh: true),
        color: Colors.orange,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 145.0,
              backgroundColor: _scrollController.hasClients && _scrollController.offset > 50 ? Colors.orange : Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 85.0, left: 16.0, right: 16.0, bottom: 10),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterProducts,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm sản phẩm...',
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white),
                                onPressed: () {
                                  _searchController.clear();
                                  _applyFilters();
                                  setState(() {});
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
              title: const Text('TH4 - Nhóm G3_C4', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
              actions: [
                ValueListenableBuilder<List<OrderModel>>(
                  valueListenable: OrderStore.instance.orders,
                  builder: (context, orders, child) {
                    final count = orders.where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.shipping).length;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 26),
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderHistoryScreen())),
                        ),
                        if (count > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                              child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            ),
                          ),
                      ],
                    );
                  },
                ),
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
                  if (_searchController.text.isEmpty && _selectedCategory == null) ...[
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
                  ],
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = _selectedCategory == category.name;
                        return GestureDetector(
                          onTap: () => _selectCategory(category.name),
                          child: Container(
                            width: 85,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: isSelected ? Colors.orange : Colors.grey[900],
                                  child: Icon(
                                    category.icon,
                                    color: isSelected ? Colors.white : Colors.orange,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSelected ? Colors.orange : Colors.white70,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Text(
                      _selectedCategory != null
                          ? 'Category: $_selectedCategory'
                          : (_searchController.text.isEmpty
                              ? 'Recommended for you'
                              : 'Search results (${_filteredProducts.length})'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            // Loading initial state
            if (_isLoading && _allProducts.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: Colors.orange)),
              )
            else if (_filteredProducts.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text('No products found!', style: TextStyle(color: Colors.white60)),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = _filteredProducts[index];
                      return _buildProductCard(context, product, cart);
                    },
                    childCount: _filteredProducts.length,
                  ),
                ),
              ),

            // Loading more indicator
            if (_isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator(color: Colors.orange)),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, CartProvider cart) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
      },
      child: Card(
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
                  Hero(
                    tag: 'product-${product.id}',
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Image.network(product.imageUrl, fit: BoxFit.contain),
                    ),
                  ),
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
                  Text(product.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('Sold ${product.sold}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white10,
                        foregroundColor: Colors.orange,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.orange, width: 0.5)),
                      ),
                      child: const Text('View Detail', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
