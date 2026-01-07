  import 'package:flutter/material.dart';
  import 'package:telekilogram/controller/cart/cart_controller.dart';
  import 'package:telekilogram/models/order_model.dart';
  import 'package:telekilogram/controller/hoaDon/orders_controller.dart';
  import 'package:telekilogram/screens/hoaDon/orders_page.dart';


  class CheckoutPage extends StatefulWidget {
    const CheckoutPage({super.key});

    @override
    State<CheckoutPage> createState() => _CheckoutPageState();
  }

  class _CheckoutPageState extends State<CheckoutPage> {
    final _formKey = GlobalKey<FormState>();

    final _nameCtrl = TextEditingController(text: "Khách hàng");
    final _phoneCtrl = TextEditingController(text: "0900000000");
    final _addrCtrl = TextEditingController(text: "Địa chỉ (demo)");
    final _noteCtrl = TextEditingController();

    bool _loading = false;

    @override
    void dispose() {
      _nameCtrl.dispose();
      _phoneCtrl.dispose();
      _addrCtrl.dispose();
      _noteCtrl.dispose();
      super.dispose();
    }

    String _genOrderId() {
      final now = DateTime.now();
      String two(int x) => x.toString().padLeft(2, '0');
      return "${now.year}${two(now.month)}${two(now.day)}-${two(now.hour)}${two(now.minute)}${two(now.second)}";
    }

    Future<void> _createOrder() async {
      if (cart.totalQty == 0) return;
      if (!_formKey.currentState!.validate()) return;

      setState(() => _loading = true);
      await Future.delayed(const Duration(milliseconds: 500)); // giả lập

      final items = cart.items
      .map((c) => OrderItem(
            productId: c.product.id,
            title: c.product.title,
            price: (c.product.price as num).toInt(), // ✅ FIX: ép num -> int
            qty: c.qty,
            thumbnail: c.product.thumbnail,
          ))
      .toList();


      final order = Order(
        id: _genOrderId(),
        createdAt: DateTime.now(),
        customerName: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addrCtrl.text.trim(),
        note: _noteCtrl.text.trim(),
        items: items,
        status: OrderStatus.unpaid, // ✅ QUAN TRỌNG: mới tạo là CHƯA THANH TOÁN
      );

      orders.add(order);
      cart.clear();

      if (!mounted) return;
      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tạo đơn hàng thành công ✅ (Chưa thanh toán)")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const OrdersPage()),
        (route) => route.isFirst,
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text("Xác nhận đơn hàng")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_bag),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Tổng tiền: \$${cart.totalPrice}\nSố lượng: ${cart.totalQty}",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: "Tên khách", border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Nhập tên khách" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneCtrl,
                  decoration: const InputDecoration(labelText: "SĐT", border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Nhập SĐT" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _addrCtrl,
                  decoration: const InputDecoration(labelText: "Địa chỉ", border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Nhập địa chỉ" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(labelText: "Ghi chú", border: OutlineInputBorder()),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _createOrder,
                    child: _loading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text("Tạo đơn hàng (Chưa thanh toán)"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }