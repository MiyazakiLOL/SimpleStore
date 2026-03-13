import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MovieWebApp());
}

class Movie {
  final String title;
  final String posterUrl;
  final String tag;
  final double rating;
  final int views;
  final String genre;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.tag,
    required this.rating,
    required this.views,
    required this.genre,
  });
}

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}

class MovieWebApp extends StatelessWidget {
  const MovieWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Manager',
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

  List<String> banners = [
    'https://picsum.photos/seed/movieCover/1200/400',
    'https://picsum.photos/seed/movie2/1200/400',
    'https://picsum.photos/seed/movie3/1200/400',
    'https://picsum.photos/seed/movie4/1200/400',
  ];

  List<Category> categories = [
    Category(name: 'Action', icon: Icons.flash_on),
    Category(name: 'Romance', icon: Icons.favorite),
    Category(name: 'Horror', icon: Icons.visibility_off),
    Category(name: 'Comedy', icon: Icons.sentiment_very_satisfied),
    Category(name: 'Sci-Fi', icon: Icons.rocket),
    Category(name: 'Drama', icon: Icons.theater_comedy),
  ];

  List<Movie> movies = [
    Movie(
      title: 'Inception',
      posterUrl: 'https://picsum.photos/seed/inception/300/450',
      tag: 'HD',
      rating: 8.8,
      views: 2500000,
      genre: 'Sci-Fi',
    ),
    Movie(
      title: 'The Shawshank Redemption',
      posterUrl: 'https://picsum.photos/seed/shawshank/300/450',
      tag: 'Top Rated',
      rating: 9.3,
      views: 3000000,
      genre: 'Drama',
    ),
    Movie(
      title: 'The Dark Knight',
      posterUrl: 'https://picsum.photos/seed/darkknight/300/450',
      tag: 'New',
      rating: 9.0,
      views: 2800000,
      genre: 'Action',
    ),
    Movie(
      title: 'Pulp Fiction',
      posterUrl: 'https://picsum.photos/seed/pulpfiction/300/450',
      tag: 'Trending',
      rating: 8.9,
      views: 2200000,
      genre: 'Crime',
    ),
    Movie(
      title: 'Forrest Gump',
      posterUrl: 'https://picsum.photos/seed/forrestgump/300/450',
      tag: 'HD',
      rating: 8.8,
      views: 2600000,
      genre: 'Drama',
    ),
    Movie(
      title: 'The Matrix',
      posterUrl: 'https://picsum.photos/seed/matrix/300/450',
      tag: 'Top Rated',
      rating: 8.7,
      views: 2400000,
      genre: 'Sci-Fi',
    ),
    Movie(
      title: 'Titanic',
      posterUrl: 'https://picsum.photos/seed/titanic/300/450',
      tag: 'New',
      rating: 7.8,
      views: 3500000,
      genre: 'Romance',
    ),
    Movie(
      title: 'Avatar',
      posterUrl: 'https://picsum.photos/seed/avatar/300/450',
      tag: 'Trending',
      rating: 7.8,
      views: 4000000,
      genre: 'Sci-Fi',
    ),
    Movie(
      title: 'The Godfather',
      posterUrl: 'https://picsum.photos/seed/godfather/300/450',
      tag: 'HD',
      rating: 9.2,
      views: 2700000,
      genre: 'Crime',
    ),
    Movie(
      title: 'Interstellar',
      posterUrl: 'https://picsum.photos/seed/interstellar/300/450',
      tag: 'Top Rated',
      rating: 8.6,
      views: 2300000,
      genre: 'Sci-Fi',
    ),
    Movie(
      title: 'The Avengers',
      posterUrl: 'https://picsum.photos/seed/avengers/300/450',
      tag: 'New',
      rating: 8.0,
      views: 3200000,
      genre: 'Action',
    ),
    Movie(
      title: 'Joker',
      posterUrl: 'https://picsum.photos/seed/joker/300/450',
      tag: 'Trending',
      rating: 8.4,
      views: 2900000,
      genre: 'Drama',
    ),
    Movie(
      title: 'Parasite',
      posterUrl: 'https://picsum.photos/seed/parasite/300/450',
      tag: 'HD',
      rating: 8.5,
      views: 2100000,
      genre: 'Thriller',
    ),
    Movie(
      title: 'The Lion King',
      posterUrl: 'https://picsum.photos/seed/lionking/300/450',
      tag: 'Top Rated',
      rating: 8.5,
      views: 3800000,
      genre: 'Animation',
    ),
    Movie(
      title: 'Frozen',
      posterUrl: 'https://picsum.photos/seed/frozen/300/450',
      tag: 'New',
      rating: 7.4,
      views: 4200000,
      genre: 'Animation',
    ),
    Movie(
      title: 'Spider-Man: No Way Home',
      posterUrl: 'https://picsum.photos/seed/spiderman/300/450',
      tag: 'Trending',
      rating: 8.2,
      views: 3100000,
      genre: 'Action',
    ),
    Movie(
      title: 'The Batman',
      posterUrl: 'https://picsum.photos/seed/batman/300/450',
      tag: 'HD',
      rating: 7.8,
      views: 2600000,
      genre: 'Action',
    ),
    Movie(
      title: 'Dune',
      posterUrl: 'https://picsum.photos/seed/dune/300/450',
      tag: 'Top Rated',
      rating: 8.0,
      views: 2000000,
      genre: 'Sci-Fi',
    ),
    Movie(
      title: 'Black Widow',
      posterUrl: 'https://picsum.photos/seed/blackwidow/300/450',
      tag: 'New',
      rating: 6.7,
      views: 1800000,
      genre: 'Action',
    ),
    Movie(
      title: 'Wonder Woman',
      posterUrl: 'https://picsum.photos/seed/wonderwoman/300/450',
      tag: 'Trending',
      rating: 7.4,
      views: 2500000,
      genre: 'Action',
    ),
  ];

  bool _isLoading = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
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
    });
  }

  Future<void> _refreshMovies() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      movies = [
        Movie(
          title: 'Refreshed Inception',
          posterUrl: 'https://picsum.photos/seed/refreshed1/300/450',
          tag: 'New',
          rating: 8.0,
          views: 200000,
          genre: 'Action',
        ),
        Movie(
          title: 'Refreshed Shawshank',
          posterUrl: 'https://picsum.photos/seed/refreshed2/300/450',
          tag: 'New',
          rating: 8.0,
          views: 200000,
          genre: 'Drama',
        ),
        // Add more as needed
      ];
      _currentPage = 1;
    });
  }

  void _loadMoreMovies() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      movies.addAll([
        Movie(
          title: 'Loaded Inception',
          posterUrl: 'https://picsum.photos/seed/loaded1/300/450',
          tag: 'More',
          rating: 6.5,
          views: 50000,
          genre: 'Drama',
        ),
        Movie(
          title: 'Loaded Shawshank',
          posterUrl: 'https://picsum.photos/seed/loaded2/300/450',
          tag: 'More',
          rating: 6.5,
          views: 50000,
          genre: 'Drama',
        ),
        // Add more as needed
      ]);
      _currentPage++;
      _isLoading = false;
    });
  }

  void _filterByCategory(String genre) {
    // Implement filtering logic here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Filtering by $genre')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie Manager',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.bookmark),
                onPressed: () {
                  // Navigate to watchlist
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
                    '$_watchlistCount',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMovies,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Banner Carousel
            SliverToBoxAdapter(
              child: Column(
                children: [
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
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[900],
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            banners[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
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
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      banners.length,
                      (index) => Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentBannerIndex == index
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return GestureDetector(
                            onTap: () => _filterByCategory(category.name),
                            child: Container(
                              width: 80,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      category.icon,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Featured Movies (Horizontal)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Featured Movies',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length.clamp(0, 8),
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return Container(
                            width: 160,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      movie.posterUrl,
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                                  movie.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Movie Discover
            SliverToBoxAdapter(
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Discover Movies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final movie = movies[index];
                  return Card(
                    color: Colors.grey[900],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8.0),
                            ),
                            child: Image.network(
                              movie.posterUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
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
                                  movie.tag,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 16,
                                  ),
                                  Text(
                                    '${movie.rating}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${(movie.views / 1000000).toStringAsFixed(1)}M views',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }, childCount: movies.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
