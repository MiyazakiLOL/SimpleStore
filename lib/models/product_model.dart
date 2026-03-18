class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String tag;
  final double price;
  final int sold;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tag,
    required this.price,
    required this.sold,
    required this.category,
    this.description = '',
  });

  factory Product.fromFakeStore(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'],
      imageUrl: json['image'],
      tag: (json['rating']?['rate'] ?? 0) > 4.0 ? 'Hot' : 'New',
      price: (json['price'] as num).toDouble(),
      sold: (json['rating']?['count'] ?? 0),
      category: json['category'],
      description: json['description'] ?? '',
    );
  }
}
