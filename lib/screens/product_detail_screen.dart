import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'chat_screen.dart';
import 'checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedColor = "Bạc";
  int quantity = 1;
  bool isExpanded = false;

  final List<String> colors = ["Bạc", "Xám", "Xanh"];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 🔥 HERO + SLIDER (CHUẨN)
          SizedBox(
            height: 300,
            child: PageView(
              children: [
                // 👉 Ảnh đầu có Hero
                Hero(
                  tag: widget.product.id,
                  child: Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),

                // 👉 Ảnh phụ
                Image.network(widget.product.imageUrl, fit: BoxFit.cover),
                Image.network(widget.product.imageUrl, fit: BoxFit.cover),
              ],
            ),
          ),

          // 🔥 CONTENT
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔥 TÊN
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 🔥 GIÁ (SALE + GỐC)
                    Row(
                      children: [
                        Text(
                          "\$${widget.product.price}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "\$${(widget.product.price * 1.2).toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Đã bán: ${widget.product.sold}",
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    // 🔥 CHỌN MÀU
                    const Text(
                      "Chọn màu:",
                      style: TextStyle(color: Colors.white),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      children: colors.map((color) {
                        final isSelected = selectedColor == color;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? Colors.orange : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: isSelected
                                  ? Colors.orange.withOpacity(0.2)
                                  : Colors.transparent,
                            ),
                            child: Text(
                              color,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // 🔥 SỐ LƯỢNG
                    Row(
                      children: [
                        const Text(
                          "Số lượng:",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: quantity > 1
                              ? () {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.remove, color: Colors.white),
                        ),
                        Text(
                          "$quantity",
                          style: const TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 🔥 MÔ TẢ + XEM THÊM
                    const Text(
                      "Mô tả sản phẩm",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Đây là sản phẩm cao cấp với thiết kế sang trọng, hiệu năng mạnh mẽ, pin trâu, camera cực nét. Phù hợp cho học tập, làm việc và giải trí. " *
                          3,
                      maxLines: isExpanded ? null : 5,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded ? "Thu gọn" : "Xem thêm",
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔥 BUTTON
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                // 🔥 ICON BÊN TRÁI
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              productName: widget.product.name,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 10),

                // 🔥 2 NÚT BÊN PHẢI
                Expanded(
                  child: Row(
                    children: [
                      // 👉 THÊM VÀO GIỎ
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text("Thêm vào giỏ"),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // 👉 MUA NGAY (CHỈ UI)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CheckoutScreen(
                                  selectedItems: [
                                    CartItem(
                                      id: widget.product.id,
                                      name: widget.product.name,
                                      attr: selectedColor,
                                      price: widget.product.price,
                                      imageUrl: widget.product.imageUrl,
                                      quantity: quantity,
                                      isSelected: true,
                                    ),
                                  ],
                                  removeFromCartOnSuccess: false,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text("Mua ngay"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    String tempColor = selectedColor;
    int tempQty = quantity;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Chọn phân loại",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔥 MÀU
                  Wrap(
                    spacing: 10,
                    children: colors.map((color) {
                      final isSelected = tempColor == color;
                      return GestureDetector(
                        onTap: () {
                          setStateSheet(() {
                            tempColor = color;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.orange : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.transparent,
                          ),
                          child: Text(
                            color,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // 🔥 SỐ LƯỢNG
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Số lượng",
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: tempQty > 1
                                ? () {
                                    setStateSheet(() {
                                      tempQty--;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.remove, color: Colors.white),
                          ),
                          Text(
                            "$tempQty",
                            style: const TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {
                              setStateSheet(() {
                                tempQty++;
                              });
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔥 XÁC NHẬN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final cart = Provider.of<CartProvider>(
                          context,
                          listen: false,
                        );

                        cart.addToCart(
                          widget.product,
                          color: tempColor,
                          quantity: tempQty,
                        );

                        // 🔥 đóng BottomSheet
                        Navigator.of(context, rootNavigator: true).pop();

                        // 🔥 hiện snackbar (trên màn detail)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Thêm thành công"),
                            backgroundColor: Colors.orange,
                            duration: Duration(milliseconds: 800),
                          ),
                        );
                        // 🔥 Đóng ProductDetail (quay về màn hình trước đó, thường là Home)
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text("Xác nhận"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
