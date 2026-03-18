class CartItem {
  final String id;
  final String name;
  String attr;
  final double price;
  final String imageUrl;
  int quantity;
  bool isSelected;
  final List<String>? availableColors;

  CartItem({
    required this.id,
    required this.name,
    required this.attr,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.isSelected = true,
    this.availableColors,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'attr': attr,
    'price': price,
    'imageUrl': imageUrl,
    'quantity': quantity,
    'isSelected': isSelected,
    'availableColors': availableColors,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    name: json['name'],
    attr: json['attr'],
    price: (json['price'] as num).toDouble(),
    imageUrl: json['imageUrl'],
    quantity: json['quantity'],
    isSelected: json['isSelected'],
    availableColors: json['availableColors'] != null ? List<String>.from(json['availableColors']) : null,
  );
}
