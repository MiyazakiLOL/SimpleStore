import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../models/order_item.dart';
import '../models/order_model.dart';
import '../models/order_status.dart';
import '../models/payment_method.dart';
import '../providers/cart_provider.dart';
import '../providers/order_store.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> selectedItems;
  final bool removeFromCartOnSuccess;

  const CheckoutScreen({
    super.key,
    required this.selectedItems,
    this.removeFromCartOnSuccess = true,
  });

  /// Helper để tự lấy danh sách item đã tick từ `CartProvider`.
  /// Dùng khi muốn mở Checkout mà không cần tự filter ở nơi gọi.
  static Future<void> openFromCartSelection(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final selected = cart.items
        .where((e) => e.isSelected)
        .toList(growable: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(selectedItems: selected),
      ),
    );
  }

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  PaymentMethod _paymentMethod = PaymentMethod.cod;
  bool _submitting = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  double get _totalAmount {
    return widget.selectedItems.fold(
      0.0,
      (sum, e) => sum + (e.price * e.quantity),
    );
  }

  Future<void> _placeOrder() async {
    if (_submitting) return;

    final address = _addressController.text.trim();
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ nhận hàng.')),
      );
      return;
    }

    if (widget.selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chưa có sản phẩm nào được chọn để thanh toán.'),
        ),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final orderId = 'OD${DateTime.now().millisecondsSinceEpoch}';
      final items = widget.selectedItems
          .map(OrderItem.fromCartItem)
          .toList(growable: false);

      final order = OrderModel(
        id: orderId,
        items: items,
        shippingAddress: address,
        paymentMethod: _paymentMethod,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      OrderStore.instance.addOrder(order);

      // Xóa các sản phẩm đã tick khỏi giỏ.
      if (widget.removeFromCartOnSuccess) {
        try {
          final cart = context.read<CartProvider>();
          for (final item in widget.selectedItems) {
            cart.removeItem(item.id, item.attr);
          }
        } catch (_) {
          // Nếu không có CartProvider trong widget tree, bỏ qua.
        }
      }

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Đặt hàng thành công'),
            content: Text(
              'Mã đơn: $orderId\nTổng tiền: \$${order.totalAmount.toStringAsFixed(2)}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.selectedItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'Địa chỉ nhận hàng',
            child: TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: 'VD: 123 Lê Lợi, Q.1, TP.HCM',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              minLines: 2,
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Phương thức thanh toán',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SegmentedButton<PaymentMethod>(
                  segments: const [
                    ButtonSegment<PaymentMethod>(
                      value: PaymentMethod.cod,
                      label: Text('COD'),
                    ),
                    ButtonSegment<PaymentMethod>(
                      value: PaymentMethod.momo,
                      label: Text('Momo'),
                    ),
                  ],
                  selected: <PaymentMethod>{_paymentMethod},
                  onSelectionChanged: (selection) {
                    setState(() => _paymentMethod = selection.first);
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  _paymentMethod.label,
                  style: const TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Sản phẩm đã chọn (${items.length})',
            child: items.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Chưa có sản phẩm nào được tick trong giỏ hàng.',
                    ),
                  )
                : Column(
                    children: [
                      for (final item in items) _CheckoutLine(item: item),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng cộng',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${_totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _submitting ? null : _placeOrder,
              child: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Đặt Hàng'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _CheckoutLine extends StatelessWidget {
  final CartItem item;

  const _CheckoutLine({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  item.attr,
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
                const SizedBox(height: 2),
                Text(
                  'Số lượng: ${item.quantity}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
