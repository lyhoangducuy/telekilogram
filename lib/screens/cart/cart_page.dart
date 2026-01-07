import 'package:flutter/material.dart';
import 'package:telekilogram/controller/cart/cart_controller.dart';
import 'package:telekilogram/screens/hoaDon/checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cart,
      builder: (_, __) => Scaffold(
        appBar: AppBar(
          title: Text("Giỏ hàng (${cart.totalQty})"),
          actions: [
            IconButton(
              onPressed: cart.totalQty == 0
                  ? null
                  : () {
                      cart.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đã xoá toàn bộ giỏ hàng ✅")),
                      );
                    },
              icon: const Icon(Icons.delete_sweep),
              tooltip: "Xoá hết",
            ),
          ],
        ),
        body: cart.items.isEmpty
            ? const Center(child: Text("Giỏ hàng trống 🧺"))
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cart.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final item = cart.items[i];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item.product.thumbnail,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 64,
                                    height: 64,
                                    color: Colors.black12,
                                    child: const Icon(Icons.image_not_supported),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 6),
                                    Text("\$${item.product.price} x ${item.qty}  =  \$${item.lineTotal}"),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => cart.decrease(item.product.id),
                                    icon: const Icon(Icons.remove_circle_outline),
                                  ),
                                  Text("${item.qty}", style: const TextStyle(fontWeight: FontWeight.w700)),
                                  IconButton(
                                    onPressed: () => cart.increase(item.product.id),
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () => cart.remove(item.product.id),
                                icon: const Icon(Icons.delete_outline),
                                tooltip: "Xóa",
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.black12)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Tổng: \$${cart.totalPrice}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                        SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            onPressed: cart.totalQty == 0
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const CheckoutPage()),
                                    );
                                  },
                            child: const Text("Thanh toán"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
