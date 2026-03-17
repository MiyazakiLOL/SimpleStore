import 'cart_item.dart';

class OrderItem {
  final String id;
  final String name;
  final String attr;
  final double price;
  final String imageUrl;
  final int quantity;

  const OrderItem({
    required this.id,
    required this.name,
    required this.attr,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  double get lineTotal => price * quantity;

  factory OrderItem.fromCartItem(CartItem item) {
    return OrderItem(
      id: item.id,
      name: item.name,
      attr: item.attr,
      price: item.price,
      imageUrl: item.imageUrl,
      quantity: item.quantity,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'attr': attr,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromJson(Map<String, Object?> json) {
    return OrderItem(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      attr: (json['attr'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: (json['imageUrl'] as String?) ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
