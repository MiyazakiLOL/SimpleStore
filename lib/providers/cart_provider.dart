import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  CartProvider() {
    _loadFromPrefs();
  }

  List<CartItem> get items => _items;

  double get totalAmount => _items
      .where((item) => item.isSelected)
      .fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  bool get isAllSelected =>
      _items.isNotEmpty && _items.every((item) => item.isSelected);

  // ✅ Lưu vào bộ nhớ máy
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(_items.map((i) => i.toJson()).toList());
    await prefs.setString('cart_items', data);
  }

  // ✅ Tải dữ liệu khi mở app
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('cart_items');
    if (data != null) {
      final List<dynamic> decoded = json.decode(data);
      _items = decoded.map((i) => CartItem.fromJson(i)).toList();
      notifyListeners();
    }
  }

  void toggleAll(bool value) {
    for (var item in _items) {
      item.isSelected = value;
    }
    _saveToPrefs();
    notifyListeners();
  }

  void toggleItem(String id, String attr) {
    final index = _items.indexWhere((item) => item.id == id && item.attr == attr);
    if (index != -1) {
      _items[index].isSelected = !_items[index].isSelected;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void updateQuantity(String id, String attr, int delta) {
    final index = _items.indexWhere((item) => item.id == id && item.attr == attr);
    if (index != -1) {
      if (_items[index].quantity + delta > 0) {
        _items[index].quantity += delta;
      } else {
        _items.removeAt(index);
      }
      _saveToPrefs();
      notifyListeners();
    }
  }

  void removeItem(String id, String attr) {
    _items.removeWhere((item) => item.id == id && item.attr == attr);
    _saveToPrefs();
    notifyListeners();
  }

  void addToCart(Product product, {String color = "Mặc định", int quantity = 1}) {
    final index = _items.indexWhere((item) => item.id == product.id && item.attr == color);
    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(
        id: product.id,
        name: product.name,
        attr: color,
        price: product.price,
        imageUrl: product.imageUrl,
        quantity: quantity,
      ));
    }
    _saveToPrefs();
    notifyListeners();
  }
}
