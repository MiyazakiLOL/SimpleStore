import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';
import '../models/order_status.dart';

class OrderStore {
  static const String _prefsKey = 'simple_store_orders_v1';

  OrderStore._() {
    _loadFromDisk();
  }

  static final OrderStore instance = OrderStore._();

  final ValueNotifier<List<OrderModel>> orders =
      ValueNotifier<List<OrderModel>>(<OrderModel>[]);

  bool _loaded = false;

  void addOrder(OrderModel order) {
    final current = List<OrderModel>.from(orders.value);
    current.insert(0, order);
    orders.value = current;

    _saveToDisk();
  }

  void updateStatus(String orderId, OrderStatus status) {
    final current = orders.value;
    final index = current.indexWhere((o) => o.id == orderId);
    if (index == -1) return;

    final next = List<OrderModel>.from(current);
    next[index] = next[index].copyWith(status: status);
    orders.value = next;

    _saveToDisk();
  }

  List<OrderModel> getOrdersByStatus(OrderStatus status) {
    return orders.value
        .where((o) => o.status == status)
        .toList(growable: false);
  }

  Future<void> _loadFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.trim().isEmpty) {
        _loaded = true;
        return;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        _loaded = true;
        return;
      }

      final diskOrders = <OrderModel>[];
      for (final e in decoded) {
        if (e is Map) {
          diskOrders.add(OrderModel.fromJson(e.cast<String, Object?>()));
        }
      }

      final current = orders.value;
      final currentIds = current.map((e) => e.id).toSet();
      final merged = <OrderModel>[
        ...current,
        ...diskOrders.where((o) => !currentIds.contains(o.id)),
      ];

      orders.value = merged;
    } catch (_) {
    } finally {
      _loaded = true;
    }
  }

  Future<void> _saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = orders.value.map((e) => e.toJson()).toList(growable: false);
      await prefs.setString(_prefsKey, jsonEncode(list));
    } catch (_) {
    }
  }
}
