import 'order_item.dart';
import 'order_status.dart';
import 'payment_method.dart';

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final String shippingAddress;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  double get totalAmount => items.fold(0.0, (sum, e) => sum + e.lineTotal);

  OrderModel copyWith({OrderStatus? status}) {
    return OrderModel(
      id: id,
      items: items,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(growable: false),
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, Object?> json) {
    final rawItems = json['items'];
    final items = <OrderItem>[];
    if (rawItems is List) {
      for (final e in rawItems) {
        if (e is Map) {
          items.add(OrderItem.fromJson(e.cast<String, Object?>()));
        }
      }
    }

    final paymentName =
        (json['paymentMethod'] as String?) ?? PaymentMethod.cod.name;
    final statusName = (json['status'] as String?) ?? OrderStatus.pending.name;
    final createdAtRaw = json['createdAt'] as String?;

    PaymentMethod paymentMethod;
    try {
      paymentMethod = PaymentMethod.values.byName(paymentName);
    } catch (_) {
      paymentMethod = PaymentMethod.cod;
    }

    OrderStatus status;
    try {
      status = OrderStatus.values.byName(statusName);
    } catch (_) {
      status = OrderStatus.pending;
    }

    DateTime createdAt;
    try {
      createdAt = createdAtRaw != null
          ? DateTime.parse(createdAtRaw)
          : DateTime.now();
    } catch (_) {
      createdAt = DateTime.now();
    }

    return OrderModel(
      id: (json['id'] as String?) ?? '',
      items: items,
      shippingAddress: (json['shippingAddress'] as String?) ?? '',
      paymentMethod: paymentMethod,
      status: status,
      createdAt: createdAt,
    );

  }
}
