import 'package:flutter/material.dart';
import 'package:telekilogram/api/api.dart';
import 'package:telekilogram/controller/cart/cart_controller.dart';
import 'package:telekilogram/models/product.dart';
import 'package:telekilogram/screens/cart/cart_page.dart';


class ProductDetailPage extends StatefulWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _loading = false;
  Product? _p;
  int _qty = 1;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final p = await testApi.getProductById(widget.productId);
      if (!mounted) return;
      setState(() => _p = p);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi ❌ ${e.toString().replaceFirst('Exception: ', '')}")),
      );
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết sản phẩm"),
        actions: [
          AnimatedBuilder(
            animation: cart,
            builder: (_, __) => IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
              },
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cart.totalQty > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "${cart.totalQty}",
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_p == null)
              ? const SizedBox.shrink()
              : _DetailBody(
                  p: _p!,
                  qty: _qty,
                  onQtyChanged: (v) => setState(() => _qty = v),
                ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Product p;
  final int qty;
  final ValueChanged<int> onQtyChanged;

  const _DetailBody({
    required this.p,
    required this.qty,
    required this.onQtyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final images = p.images.isNotEmpty ? p.images : [p.thumbnail];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ảnh
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AspectRatio(
            aspectRatio: 1.3,
            child: PageView.builder(
              itemCount: images.length,
              itemBuilder: (_, i) => Image.network(
                images[i],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.black12,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        Text(
          p.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _Chip(text: p.category),
            if (p.brand.isNotEmpty) _Chip(text: p.brand),
            _Chip(text: "⭐ ${p.rating}"),
          ],
        ),

        const SizedBox(height: 12),
        Text(
          "\$${p.price}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),

        const SizedBox(height: 10),
        Text(
          p.description,
          style: const TextStyle(color: Colors.black87, height: 1.35),
        ),

        const SizedBox(height: 18),

        // qty control
        Row(
          children: [
            const Text("Số lượng:", style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(width: 12),
            IconButton(
              onPressed: qty <= 1 ? null : () => onQtyChanged(qty - 1),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text("$qty", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            IconButton(
              onPressed: () => onQtyChanged(qty + 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
            const Spacer(),
            Text(
              "Tạm tính: \$${p.price * qty}",
              style: const TextStyle(fontWeight: FontWeight.w800),
            )
          ],
        ),

        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              cart.add(p, qty: qty);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đã thêm vào giỏ ✅")),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text("Thêm vào giỏ hàng"),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
