import 'package:flutter/material.dart';
import 'cart_item.dart';
import 'product_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = []; // ❌ bỏ dữ liệu fake

  List<CartItem> get items => _items;

  // ✅ Tổng tiền (chỉ tính item được chọn)
  double get totalAmount => _items
      .where((item) => item.isSelected)
      .fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  // ✅ Check chọn tất cả
  bool get isAllSelected =>
      _items.isNotEmpty && _items.every((item) => item.isSelected);

  // ✅ Chọn tất cả
  void toggleAll(bool value) {
    for (var item in _items) {
      item.isSelected = value;
    }
    notifyListeners();
  }

  // ✅ Chọn từng item
  void toggleItem(String id, String attr) {
    final index =
        _items.indexWhere((item) => item.id == id && item.attr == attr);

    if (index != -1) {
      _items[index].isSelected = !_items[index].isSelected;
      notifyListeners();
    }
  }

  // ✅ Cập nhật màu
  void updateColor(String id, String attr, String newColor) {
    final index =
        _items.indexWhere((item) => item.id == id && item.attr == attr);

    if (index != -1) {
      _items[index].attr = newColor;
      notifyListeners();
    }
  }

  // ✅ Tăng giảm số lượng
  void updateQuantity(String id, String attr, int delta) {
    final index =
        _items.indexWhere((item) => item.id == id && item.attr == attr);

    if (index != -1 && _items[index].quantity + delta > 0) {
      _items[index].quantity += delta;
      notifyListeners();
    }
  }

  // ✅ Xoá đúng item (id + màu)
  void removeItem(String id, String attr) {
    _items.removeWhere((item) => item.id == id && item.attr == attr);
    notifyListeners();
  }

  // ✅ THÊM VÀO GIỎ (QUAN TRỌNG NHẤT)
  void addToCart(Product product,
      {String color = "Mặc định", int quantity = 1}) {
    final index = _items.indexWhere(
      (item) => item.id == product.id && item.attr == color,
    );

    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          id: product.id,
          name: product.name,
          attr: color,
          price: product.price,
          imageUrl: product.imageUrl,
          quantity: quantity,
        ),
      );
    }

    notifyListeners();
  }
}